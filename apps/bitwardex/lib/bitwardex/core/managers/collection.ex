defmodule Bitwardex.Core.Managers.Collection do
  import Ecto.Query, warn: false
  alias Bitwardex.Repo

  alias Bitwardex.Core.Queries.Collection, as: CollectionQuery
  alias Bitwardex.Core.Schemas.Collection

  def list_collections(organization_id) do
    Collection
    |> CollectionQuery.by_organization(organization_id)
    |> Repo.all()
  end

  def get_collection_by_organization(organization_id, collection_id) do
    Collection
    |> CollectionQuery.by_organization(organization_id)
    |> Repo.get(collection_id)
    |> case do
      %Collection{} = collection -> {:ok, collection}
      nil -> {:error, :not_found}
    end
  end

  def get_collection_by_user(user_id, collection_id) do
    Collection
    |> CollectionQuery.by_user(user_id)
    |> Repo.get(collection_id)
    |> case do
      %Collection{} = collection -> {:ok, collection}
      nil -> {:error, :not_found}
    end
  end

  def create_collection(attrs \\ %{}) do
    %Collection{}
    |> Collection.changeset(attrs)
    |> Repo.insert()
  end

  def update_collection(%Collection{} = collection, attrs) do
    collection
    |> Collection.changeset(attrs)
    |> Repo.update()
  end

  def delete_collection(%Collection{} = collection) do
    Repo.delete(collection)
  end
end
