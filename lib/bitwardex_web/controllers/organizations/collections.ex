defmodule BitwardexWeb.Organizations.CollectionsController do
  @moduledoc """
  Controller to handle accounts-related operations
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Accounts
  alias Bitwardex.Core

  alias BitwardexWeb.Organizations.CollectionsView

  alias Bitwardex.Repo

  def index(conn, %{"organization_id" => organization_id}) do
    collections_json =
      organization_id
      |> Core.list_collections()
      |> Enum.map(fn collection ->
        CollectionsView.render("collection.json", %{collection: collection})
      end)

    json(conn, %{
      "Data" => collections_json,
      "Object" => "list",
      "ContinuationToken" => nil
    })
  end

  def show(conn, %{"organization_id" => organization_id, "id" => id}) do
    {:ok, collection} = Core.get_collection_by_organization(organization_id, id)

    conn
    |> assign(:collection, collection)
    |> render("collection.json")
  end

  def create(conn, %{"organization_id" => organization_id, "name" => name}) do
    {:ok, _organization} = Accounts.get_organization(organization_id)

    {:ok, collection} = Core.create_collection(%{organization_id: organization_id, name: name})

    conn
    |> assign(:collection, collection)
    |> render("collection.json")
  end

  def update(conn, %{"organization_id" => organization_id, "id" => id, "name" => name}) do
    {:ok, collection} = Core.get_collection_by_organization(organization_id, id)

    {:ok, updated_collection} = Core.update_collection(collection, %{name: name})

    conn
    |> assign(:collection, updated_collection)
    |> render("collection.json")
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
      |> Repo.preload(collection_users: [:user_organization])
      |> Map.get(:collection_users)
      |> Enum.map(fn collection_user ->
        CollectionsView.render("collection_user.json", %{collection_user: collection_user})
      end)

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
end
