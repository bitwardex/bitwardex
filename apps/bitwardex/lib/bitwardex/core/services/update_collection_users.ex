defmodule Bitwardex.Core.Services.UpdateCollectionUsers do
  @moduledoc """
  Service to update the users assigned to a collection
  """

  import Ecto.Query

  alias Bitwardex.Accounts.Schemas.UserCollection
  alias Bitwardex.Core.Schemas.Collection

  alias Bitwardex.Repo

  alias Ecto.Multi

  def call(%Collection{} = collection, users_data) do
    org_user_ids = Enum.map(users_data, fn ud -> Map.fetch!(ud, :user_id) end)

    organization_user_ids =
      collection
      |> Repo.preload(organization: [:organization_users])
      |> Map.get(:organization)
      |> Map.get(:organization_users)
      |> Enum.map(fn ou -> ou.id end)

    # Check that all users received belongs to the organization
    case Enum.find(org_user_ids, &(&1 not in organization_user_ids)) do
      nil ->
        users_to_remove =
          from uc in UserCollection,
            where:
              uc.collection_id == ^collection.id and uc.user_organization_id not in ^org_user_ids

        Multi.new()
        |> Multi.delete_all(:users_removed, users_to_remove)
        |> Multi.run(:users_added_updated, &add_or_update_users(&1, collection, users_data))
        |> Repo.transaction()

      user_id ->
        {:error, {:user_not_in_organization, user_id}}
    end
  end

  defp add_or_update_users(_repo, collection, users_data) do
    collection_users =
      collection
      |> Repo.preload(:collection_users)
      |> Map.get(:collection_users)

    users_data
    |> Enum.map(fn %{user_id: org_user_id, read_only: read_only} ->
      case Enum.find(collection_users, &(&1.user_organization_id == org_user_id)) do
        %UserCollection{} = cu ->
          # Update user that is already assigned
          cu
          |> UserCollection.changeset(%{read_only: read_only})
          |> Repo.update()

        nil ->
          # Assign a user to the colelction that jas not been asigned previously
          %UserCollection{}
          |> UserCollection.changeset(%{
            collection_id: collection.id,
            user_organization_id: org_user_id,
            read_only: read_only
          })
          |> Repo.insert()
      end
    end)
    |> Enum.reduce(%{ok: [], error: []}, fn result, acc ->
      case result do
        {:ok, res} -> %{ok: [res | acc[:ok]], error: acc[:error]}
        {:error, err} -> %{ok: acc[:ok], error: [err | acc[:error]]}
      end
    end)
    |> case do
      %{ok: res, error: []} -> {:ok, res}
      %{ok: _res, error: err} -> {:error, err}
    end
  end
end
