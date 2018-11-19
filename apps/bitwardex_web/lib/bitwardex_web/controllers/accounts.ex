defmodule BitwardexWeb.AccountsController do
  @moduledoc """
  Controller to handle accounts-related operations
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Accounts
  alias Bitwardex.Accounts.Schemas.User

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

  def login(conn, %{"username" => username, "password" => password, "grant_type" => "password"}) do
    case Accounts.get_user_by_email(username) do
      {:ok, %User{master_password_hash: ^password} = user} ->
        claims = Accounts.generate_user_claims(user)

        {:ok, access_token, _claims} =
          BitwardexWeb.Guardian.encode_and_sign(user, claims, token_type: "access")

        {:ok, refresh_token, _claims} =
          BitwardexWeb.Guardian.encode_and_sign(user, claims, token_type: "refresh")

        conn
        |> put_status(200)
        |> json(%{
          "access_token" => access_token,
          "expires_in" => 3600,
          "token_type" => "Bearer",
          "refresh_token" => refresh_token,
          "Key" => user.key
        })

      _error ->
        invalid_user_response(conn)
    end
  end

  def login(conn, _params), do: invalid_user_response(conn)

  defp invalid_user_response(conn) do
    conn
    |> put_status(400)
    |> json(%{
      "error" => "invalid_grant",
      "error_description" => "invalid_username_or_password",
      "ErrorModel" => %{
        "Message" => "Username or password is incorrect. Try again.",
        "ValidationErrors" => nil,
        "ExceptionMessage" => nil,
        "ExceptionStackTrace" => nil,
        "InnerExceptionMessage" => nil,
        "Object" => "error"
      }
    })
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
