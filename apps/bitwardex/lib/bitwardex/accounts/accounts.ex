defmodule Bitwardex.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Bitwardex.Accounts.Managers.Organization, as: OrganizationManager
  alias Bitwardex.Accounts.Managers.User, as: UserManager
  alias Bitwardex.Accounts.Managers.UserOrganization, as: UserOrganizationManager

  # Users

  defdelegate get_user(id), to: UserManager
  defdelegate get_user_by_email(email), to: UserManager
  defdelegate create_user(params), to: UserManager
  defdelegate update_user(user, params), to: UserManager
  defdelegate delete_user(user), to: UserManager
  defdelegate change_user(user), to: UserManager

  defdelegate generate_user_claims(user),
    to: Bitwardex.Accounts.Services.GenerateUserClaims,
    as: :call

  # Organizations

  defdelegate get_organization(id), to: OrganizationManager
  defdelegate create_organization(params), to: OrganizationManager
  defdelegate update_organization(organization, params), to: OrganizationManager
  defdelegate delete_organization(organization), to: OrganizationManager

  defdelegate create_organization(params, user),
    to: Bitwardex.Accounts.Services.CreateOrganization,
    as: :call

  defdelegate invite_organization_user(organization, email, type, access_all, collections),
    to: Bitwardex.Accounts.Services.InviteOrganizationUser,
    as: :call

  # UserOrganizations

  defdelegate get_user_organization(organization, id), to: UserOrganizationManager
  defdelegate create_user_organization(params), to: UserOrganizationManager
  defdelegate update_user_organization(user_organization, params), to: UserOrganizationManager
  defdelegate delete_user_organization(user_organization), to: UserOrganizationManager
end
