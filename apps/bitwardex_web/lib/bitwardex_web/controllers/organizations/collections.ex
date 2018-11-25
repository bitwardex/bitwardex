defmodule BitwardexWeb.Organizations.CollectionsController do
  @moduledoc """
  Controller to handle accounts-related operations
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Accounts
  alias Bitwardex.Accounts.Schemas.UserCollection
  alias Bitwardex.Core

  alias Bitwardex.Repo

  def index(conn, %{"organization_id" => organization_id}) do
    collections = Core.list_collections(organization_id)

    json(conn, %{
      "Data" => collections,
      "Object" => "list",
      "ContinuationToken" => nil
    })
  end

  def show(conn, %{"organization_id" => organization_id, "id" => id}) do
    {:ok, collection} = Core.get_collection_by_organization(organization_id, id)

    json(conn, collection)
  end

  def create(conn, %{"organization_id" => organization_id, "name" => name}) do
    {:ok, _organization} = Accounts.get_organization(organization_id)

    {:ok, collection} = Core.create_collection(%{organization_id: organization_id, name: name})

    json(conn, collection)
  end

  def update(conn, %{"organization_id" => organization_id, "id" => id, "name" => name}) do
    {:ok, collection} = Core.get_collection_by_organization(organization_id, id)

    {:ok, updated_collection} = Core.update_collection(collection, %{name: name})
    json(conn, updated_collection)
  end

  def delete(conn, %{"organization_id" => organization_id, "id" => id}) do
    {:ok, collection} = Core.get_collection_by_organization(organization_id, id)

    {:ok, _updated_collection} = Core.delete_collection(collection)
    resp(conn, 200, "")
  end

  def get_users(conn, %{"organization_id" => organization_id, "id" => id}) do
    {:ok, collection} = Core.get_collection_by_organization(organization_id, id)

    users =
      collection
      |> Repo.preload(collection_users: [:user])
      |> Map.get(:collection_users)
      |> Enum.map(&encode_collection_users_details/1)

    json(conn, users)
  end

  def update_users(
        conn,
        %{"organization_id" => organization_id, "id" => id, "_json" => users_data}
      ) do
    {:ok, collection} = Core.get_collection_by_organization(organization_id, id)

    users =
      Enum.map(users_data, fn user_data ->
        %{
          user_id: Map.fetch!(user_data, "id"),
          read_only: Map.fetch!(user_data, "read_only")
        }
      end)

    case Core.update_collection_users(collection, users) do
      {:ok, _response} -> resp(conn, 200, "")
      {:error, _} -> resp(conn, 500, "")
    end
  end

  defp encode_collection_users_details(%UserCollection{} = collection_user) do
    %{
      "Id" => collection_user.user.id,
      "ReadOnly" => collection_user.read_only
    }
  end
end
