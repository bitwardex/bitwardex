defmodule Bitwardex.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Bitwardex.Accounts.Managers.Organization, as: OrganizationManager
  alias Bitwardex.Accounts.Managers.User, as: UserManager

  defdelegate get_user(id), to: UserManager
  defdelegate get_user_by_email(email), to: UserManager
  defdelegate create_user(params), to: UserManager
  defdelegate update_user(user, params), to: UserManager
  defdelegate delete_user(user), to: UserManager
  defdelegate change_user(user), to: UserManager

  defdelegate generate_user_claims(user),
    to: Bitwardex.Accounts.Services.GenerateUserClaims,
    as: :call

  defdelegate get_organization(id), to: OrganizationManager
  defdelegate create_organization(params), to: OrganizationManager
  defdelegate update_organization(organization, params), to: OrganizationManager
  defdelegate delete_organization(organization), to: OrganizationManager

  defdelegate create_organization(params, user),
    to: Bitwardex.Accounts.Services.CreateOrganization,
    as: :call
end
