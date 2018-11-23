defmodule Bitwardex.Accounts.Services.CreateOrganization do
  @moduledoc false

  alias Bitwardex.Accounts.Schemas.Organization
  alias Bitwardex.Core.Managers.Collection
  alias Ecto.Multi
  alias Bitwardex.Repo
  alias Bitwardex.Accounts.Schemas.UserCollection
  alias Bitwardex.Accounts.Schemas.UserOrganization

  def call(params, user) do
    Multi.new()
    |> Multi.insert(:organization, Organization.changeset(%Organization{}, params))
    |> Multi.run(:collection, &create_collection(&1, &2, params))
    |> Multi.run(:user_collection, &create_user_collection(&1, &2, user))
    |> Multi.run(:user_organization, &create_user_organization(&1, &2, params, user))
    |> Repo.transaction()
  end

  defp create_collection(_repo, %{organization: organization}, params) do
    Collection.create_collection(%{
      "name" => params["collection_name"],
      "organization_id" => organization.id
    })
  end

  defp create_user_collection(_repo, %{collection: collection}, user) do
    %UserCollection{}
    |> UserCollection.changeset(%{user_id: user.id, collection_id: collection.id})
    |> Repo.insert()
  end

  defp create_user_organization(_repo, %{organization: organization}, params, user) do
    %UserOrganization{}
    |> UserOrganization.changeset(%{
      access_all: true,
      key: params["key"],
      # confirmed
      status: 2,
      # owner
      type: 0,
      user_id: user.id,
      organization_id: organization.id
    })
    |> Repo.insert()
  end
end
