defmodule Bitwardex.Accounts.Services.CreateOrganization do
  @moduledoc false

  alias Bitwardex.Accounts.Schemas.Organization
  alias Bitwardex.Accounts.Schemas.UserOrganization
  alias Bitwardex.Core.Managers.Collection
  alias Bitwardex.Repo

  alias Ecto.Multi

  def call(params, user) do
    if check_creation_permission() do
      Multi.new()
      |> Multi.insert(:organization, Organization.changeset(%Organization{}, params))
      |> Multi.run(:collection, &create_collection(&1, &2, params))
      |> Multi.run(:user_organization, &create_user_organization(&1, &2, params, user))
      |> Repo.transaction()
    else
      {:error, :not_allowed}
    end
  end

  defp create_collection(_repo, %{organization: organization}, params) do
    Collection.create_collection(%{
      "name" => params["collection_name"],
      "organization_id" => organization.id
    })
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

  defp check_creation_permission do
    :bitwardex
    |> Application.get_env(Bitwardex.Accounts, Keyword.new())
    |> Keyword.get(:create_organizations, true)
    |> case do
      valid when valid in ["false", false, 0] -> false
      _ -> true
    end
  end
end
