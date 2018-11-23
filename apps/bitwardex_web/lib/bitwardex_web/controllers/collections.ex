defmodule BitwardexWeb.CollectionsController do
  @moduledoc """
  Controller to handle accounts-related operations
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Accounts
  alias Bitwardex.Core

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
end
