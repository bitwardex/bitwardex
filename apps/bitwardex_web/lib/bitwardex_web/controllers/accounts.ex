defmodule BitwardexWeb.AccountsController do
  @moduledoc """
  Controller to handle accounts-related operations
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Accounts

  def register(conn, params) do
    user_params = parse_user_params(params)

    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        resp(conn, 200, "")

      {:error, _ch} ->
        # TOOD send errors
        resp(conn, 500, "")
    end
  end

  def prelogin(conn, %{"email" => email}) do
    case Accounts.get_user_by_email(email) do
      {:ok, user} ->
        json(conn, %{
          "Kdf" => user.kdf,
          "KdfIterations" => user.kdf_iterations
        })
      {:error, :not_found} ->
        # TODO: Check this is correct
        resp(conn, 404, "")
    end
  end

  def prelogin(conn, _params) do
    resp(conn, 404, "")
  end

  defp parse_user_params(params) do
    %{
      name: Map.get(params, "name"),
      email: Map.get(params, "email"),
      master_password_hash: Map.get(params, "masterPasswordHash"),
      master_password_hint: Map.get(params, "masterPasswordHint"),
      key: Map.get(params, "key"),
      kdf: Map.get(params, "kdf"),
      kdf_iterations: Map.get(params, "kdfIterations")
    }
  end
end
