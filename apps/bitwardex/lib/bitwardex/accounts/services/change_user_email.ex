defmodule Bitwardex.Accounts.Services.ChangeUserEmail do
  @moduledoc false

  alias Bitwardex.Accounts.Managers.User, as: UserManager
  alias Bitwardex.Accounts.Schemas.User

  def call(%User{master_password_hash: password_hash} = user, password_hash, new_email) do
    case UserManager.update_user(user, %{email: new_email}) do
      {:ok, updated_user} ->
        {:ok, updated_user}

      {:error, err} ->
        with %Ecto.Changeset{} <- err,
             true <- Keyword.has_key?(err.errors, :email) do
          {:error, :invalid_email}
        else
          _ -> {:error, :unknown_error}
        end
    end
  end

  def call(_, _, _), do: {:error, :invalid_master_password}
end
