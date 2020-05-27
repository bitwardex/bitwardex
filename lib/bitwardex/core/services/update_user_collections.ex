defmodule Bitwardex.Core.Services.UpdateUserCollections do
  @moduledoc """
  Service to update the users assigned to a collection
  """

  import Ecto.Query

  alias Bitwardex.Accounts.Schemas.UserCollection
  alias Bitwardex.Accounts.Schemas.UserOrganization

  alias Bitwardex.Repo

  alias Ecto.Multi

  def call(%UserOrganization{} = org_user, collections) do
    collection_ids = Enum.map(collections, fn collection -> Map.fetch!(collection, :id) end)

    organization_collection_ids =
      org_user
      |> Repo.preload(organization: [:collections])
      |> Map.get(:organization)
      |> Map.get(:collections)
      |> Enum.map(fn col -> col.id end)

    # Check that all users received belongs to the organization
    case Enum.find(collection_ids, &(&1 not in organization_collection_ids)) do
      nil ->
        user_collections_to_remove =
          from uc in UserCollection,
            where:
              uc.user_organization_id == ^org_user.id and uc.collection_id not in ^collection_ids

        Multi.new()
        |> Multi.delete_all(:user_collections_removed, user_collections_to_remove)
        |> Multi.run(
          :user_collectionss_added_updated,
          fn repo, _ ->
            add_or_update_user_collections(repo, org_user, collections)
          end
        )
        |> Repo.transaction()

      collection_id ->
        {:error, {:collection_not_in_organization, collection_id}}
    end
  end

  defp add_or_update_user_collections(repo, org_user, collections) do
    user_collections =
      org_user
      |> repo.preload(:user_collections)
      |> Map.get(:user_collections)

    collections
    |> Enum.map(fn %{id: collection_id, read_only: read_only} ->
      case Enum.find(user_collections, &(&1.collection_id == collection_id)) do
        %UserCollection{} = cu ->
          # Update user that is already assigned
          cu
          |> UserCollection.changeset(%{read_only: read_only})
          |> repo.update()

        nil ->
          # Assign a user to the colelction that jas not been asigned previously
          %UserCollection{}
          |> UserCollection.changeset(%{
            collection_id: collection_id,
            user_organization_id: org_user.id,
            read_only: read_only
          })
          |> repo.insert()
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
