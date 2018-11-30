defmodule Bitwardex.Accounts.Services.InviteOrganizationUser do
  @moduledoc """
  Service to invite a user to an organization
  """

  alias Bitwardex.Accounts
  alias Bitwardex.Accounts.Schemas.Organization
  alias Bitwardex.Accounts.Schemas.User
  alias Bitwardex.Accounts.Schemas.UserCollection
  alias Bitwardex.Accounts.Schemas.UserOrganization

  alias Bitwardex.Repo

  def call(%Organization{} = organization, email, type, access_all, collections) do
    with {:ok, %User{} = user} <- Accounts.get_user_by_email(email),
         :ok <- check_user_already_invited(organization, user),
         validated_collections <- filter_collections_in_organization(organization, collections) do
      attrs = %{
        user_id: user.id,
        organization_id: organization.id,
        status: 0,
        type: type,
        access_all: access_all
      }

      user_organization_changeset = UserOrganization.changeset(%UserOrganization{}, attrs)

      Ecto.Multi.new()
      |> Ecto.Multi.insert(:user_organization, user_organization_changeset)
      |> assign_collections(access_all, validated_collections)
      |> Repo.transaction()
      |> case do
        {:ok, %{user_organization: user_org}} -> {:ok, user, user_org}
        {:error, _, err, _} -> raise RuntimeError, inspect(err)
      end
    else
      {:error, :not_found} -> {:error, :user_not_found}
    end
  end

  defp check_user_already_invited(organization, user) do
    case Repo.get_by(UserOrganization,
           user_id: user.id,
           organization_id: organization.id
         ) do
      nil -> :ok
      _ -> {:error, :user_already_invited}
    end
  end

  defp assign_collections(multi, true, _collections), do: multi
  defp assign_collections(multi, false, []), do: multi

  defp assign_collections(multi, false, collections) do
    Enum.reduce(collections, multi, fn
      %{"id" => collection_id, "read_only" => read_only}, acc_multi ->
        Ecto.Multi.run(
          acc_multi,
          {:collection, collection_id},
          fn _repo, %{user_organization: user_org} ->
            %UserCollection{}
            |> UserCollection.changeset(%{
              user_organization_id: user_org.id,
              collection_id: collection_id,
              read_only: read_only
            })
            |> Repo.insert()
          end
        )
    end)
  end

  defp filter_collections_in_organization(organization, collections) do
    available_collection_ids =
      organization
      |> Repo.preload(:collections)
      |> Map.get(:collections)
      |> Enum.map(& &1.id)

    Enum.filter(collections, fn %{"id" => collection_id} ->
      collection_id in available_collection_ids
    end)
  end
end
