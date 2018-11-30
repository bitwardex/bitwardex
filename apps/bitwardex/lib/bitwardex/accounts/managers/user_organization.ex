defmodule Bitwardex.Accounts.Managers.UserOrganization do
  import Ecto.Query, warn: false

  alias Bitwardex.Repo

  alias Bitwardex.Accounts.Schemas.Organization
  alias Bitwardex.Accounts.Schemas.UserOrganization

  def get_user_organization(%Organization{} = organization, id) do
    user_organization = Repo.get_by(UserOrganization, organization_id: organization.id, id: id)

    case user_organization do
      %UserOrganization{} = user_organization -> {:ok, user_organization}
      nil -> {:error, :not_found}
    end
  end

  def create_user_organization(params) do
    %UserOrganization{}
    |> UserOrganization.changeset(params)
    |> Repo.insert()
  end

  def update_user_organization(user_organization, params) do
    user_organization
    |> UserOrganization.changeset(params)
    |> Repo.update()
  end

  def delete_user_organization(user_organization) do
    Repo.delete(user_organization)
  end
end
