defmodule Bitwardex.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Bitwardex.Accounts.Managers.User, as: UserManager

  defdelegate get_user(id), to: UserManager
  defdelegate get_user_by_email(email), to: UserManager
  defdelegate create_user(params), to: UserManager
  defdelegate update_user(user, arams), to: UserManager
  defdelegate delete_user(user), to: UserManager
  defdelegate change_user(user), to: UserManager

  defdelegate generate_user_claims(user),
    to: Bitwardex.Accounts.Services.GenerateUserClaims,
    as: :call

  defdelegate change_user_email(user, master_password_hash, new_email),
    to: Bitwardex.Accounts.Services.ChangeUserEmail,
    as: :call

  defdelegate change_user_master_password(
                user,
                master_password_hash,
                new_master_password_hash,
                new_key
              ),
              to: Bitwardex.Accounts.Services.ChangeUserMasterPassword,
              as: :call
end
