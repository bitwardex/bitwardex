defmodule Bitwardex.Accounts.Services.ChangeUserMasterPassword do
  @moduledoc false

  alias Bitwardex.Accounts.Managers.User, as: UserManager
  alias Bitwardex.Accounts.Schemas.User

  def call(
        %User{master_password_hash: password_hash} = user,
        password_hash,
        new_password_hash,
        new_key
      ) do
    params = %{
      master_password_hash: new_password_hash,
      key: new_key
    }

    UserManager.update_user(user, params)
  end

  def call(_, _, _, _), do: {:error, :invalid_master_password}
end
