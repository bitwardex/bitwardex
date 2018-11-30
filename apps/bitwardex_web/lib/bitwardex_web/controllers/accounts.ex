defmodule BitwardexWeb.AccountsController do
  @moduledoc """
  Controller to handle accounts-related operations
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Accounts
  alias Bitwardex.Accounts.Schemas.User

  alias Bitwardex.Repo

  alias BitwardexWeb.Emails
  alias BitwardexWeb.Mailer

  def register(conn, params) do
    case Accounts.create_user(params) do
      {:ok, user} ->
        user
        |> Emails.welcome_email()
        |> Mailer.deliver_now()

        resp(conn, 200, "")

      {:error, :invalid_email} ->
        invalid_email_response(conn)

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
        generate_user_session(conn, user)

      _error ->
        invalid_user_response(conn)
    end
  end

  def login(conn, %{"grant_type" => "refresh_token", "refresh_token" => token}) do
    with {:ok, _claims} <- BitwardexWeb.Guardian.decode_and_verify(token, %{"typ" => "refresh"}),
         {:ok, user, _claims} <- BitwardexWeb.Guardian.resource_from_token(token) do
      generate_user_session(conn, user)
    else
      _ ->
        invalid_user_response(conn)
    end
  end

  def login(conn, _params), do: invalid_user_response(conn)

  def password_hint(conn, %{"email" => email}) do
    case Accounts.get_user_by_email(email) do
      {:ok, user} ->
        user
        |> Emails.master_password_hint_email()
        |> Mailer.deliver_now()

        resp(conn, 200, "")

      {:error, _} ->
        resp(conn, 404, "")
    end
  end

  def profile(conn, _params) do
    user =
      conn
      |> current_user()
      |> Repo.preload([:organizations])

    json(conn, user)
  end

  def get_public_key(conn, %{"id" => user_id}) do
    case Accounts.get_user(user_id) do
      {:ok, user} ->
        json(conn, %{
          "UserId" => user.id,
          "PublicKey" => user.keys.public_key,
          "Object" => "userKey"
        })

      _ ->
        json(
          conn,
          %{
            "error" => "unknown_error",
            "error_description" => "unknown_error",
            "ErrorModel" => %{
              "Message" => "User not found",
              "ValidationErrors" => nil,
              "ExceptionMessage" => nil,
              "ExceptionStackTrace" => nil,
              "InnerExceptionMessage" => nil,
              "Object" => "error"
            }
          }
        )
    end
  end

  def update_profile(conn, params) do
    user =
      conn
      |> current_user()
      |> Repo.preload(:organizations)

    params = %{
      culture: Map.get(params, "culture"),
      name: Map.get(params, "name"),
      master_password_hint: Map.get(params, "master_password_hint")
    }

    {:ok, updated_user} = Accounts.update_user(user, params)

    json(conn, updated_user)
  end

  def update_keys(conn, %{
        "encryptedPrivateKey" => encrypted_private_key,
        "publicKey" => public_key
      }) do
    user = current_user(conn)

    {:ok, updated_user} =
      Accounts.update_user(user, %{
        "keys" => %{
          encrypted_private_key: encrypted_private_key,
          public_key: public_key
        }
      })

    json(conn, updated_user)
  end

  def request_email_change(conn, params) do
    user = current_user(conn)
    master_password_hash = Map.get(params, "master_password_hash")
    _new_email = Map.get(params, "new_email")

    if user.master_password_hash == master_password_hash do
      resp(conn, 200, "")
    else
      conn
      |> put_status(400)
      |> json(%{
        "ValidationErrors" => %{
          "MasterPasswordHash" => [
            "Invalid current password."
          ]
        },
        "Object" => "error"
      })
    end
  end

  def change_email(conn, params) do
    user = current_user(conn)
    master_password_hash = Map.get(params, "master_password_hash")
    new_email = Map.get(params, "new_email")
    new_master_password_hash = Map.get(params, "new_master_password_hash")
    new_key = Map.get(params, "key")

    if user.master_password_hash == master_password_hash do
      params = %{
        email: new_email,
        master_password_hash: new_master_password_hash,
        key: new_key
      }

      case Accounts.update_user(user, params) do
        {:ok, _user} ->
          resp(conn, 200, "")

        {:error, :invalid_email} ->
          invalid_email_response(conn)

        {:error, _ch} ->
          resp(conn, 500, "")
      end
    else
      conn
      |> put_status(400)
      |> json(%{
        "ValidationErrors" => %{
          "MasterPasswordHash" => [
            "Invalid current password."
          ]
        },
        "Object" => "error"
      })
    end
  end

  def change_encryption(conn, params) do
    user = current_user(conn)
    master_password_hash = Map.get(params, "master_password_hash")
    new_master_password_hash = Map.get(params, "new_master_password_hash")
    new_key = Map.get(params, "key")
    new_kdf = Map.get(params, "kdf")
    new_kdf_iterations = Map.get(params, "kdf_iterations")

    if user.master_password_hash == master_password_hash do
      params = %{
        master_password_hash: new_master_password_hash,
        key: new_key,
        kdf: new_kdf,
        kdf_iterations: new_kdf_iterations
      }

      {:ok, _updated_user} = Accounts.update_user(user, params)

      resp(conn, 200, "")
    else
      conn
      |> put_status(400)
      |> json(%{
        "ValidationErrors" => %{
          "MasterPasswordHash" => [
            "Invalid current password."
          ]
        },
        "Object" => "error"
      })
    end
  end

  def change_master_password(conn, params) do
    user = current_user(conn)
    master_password_hash = Map.get(params, "master_password_hash")
    new_master_password_hash = Map.get(params, "new_master_password_hash")
    new_key = Map.get(params, "key")

    if user.master_password_hash == master_password_hash do
      params = %{
        master_password_hash: new_master_password_hash,
        key: new_key
      }

      {:ok, _updated_user} = Accounts.update_user(user, params)

      resp(conn, 200, "")
    else
      conn
      |> put_status(400)
      |> json(%{
        "ValidationErrors" => %{
          "MasterPasswordHash" => [
            "Invalid current password."
          ]
        },
        "Object" => "error"
      })
    end
  end

  def delete(conn, params) do
    user = current_user(conn)
    master_password_hash = Map.get(params, "master_password_hash")

    if user.master_password_hash == master_password_hash do
      {:ok, _user} = Accounts.delete_user(user)

      resp(conn, 200, "")
    else
      conn
      |> put_status(400)
      |> json(%{
        "ValidationErrors" => %{
          "MasterPasswordHash" => [
            "Invalid current password."
          ]
        },
        "Object" => "error"
      })
    end
  end

  def revision_date(conn, _params) do
    user = current_user(conn)

    updated_at =
      user.updated_at
      |> DateTime.to_unix(:millisecond)
      |> Integer.to_string()

    json(conn, updated_at)
  end

  defp generate_user_session(conn, user) do
    claims = Accounts.generate_user_claims(user)

    ttl = 60 * 60

    {:ok, access_token, _claims} =
      BitwardexWeb.Guardian.encode_and_sign(user, claims,
        ttl: {ttl, :seconds},
        token_type: "access"
      )

    # TODO: Move this to database and generate a ransom base64 string instead.
    # This is set to (almost) unlimited TTL because it doesn't have to change
    # in the response.
    {:ok, refresh_token, _claims} =
      BitwardexWeb.Guardian.encode_and_sign(user, claims,
        ttl: {1, :week},
        token_type: "refresh"
      )

    conn
    |> put_status(200)
    |> json(%{
      "access_token" => access_token,
      "expires_in" => ttl,
      "token_type" => "Bearer",
      "refresh_token" => refresh_token,
      "Key" => user.key,
      "PrivateKey" => user.keys.encrypted_private_key
    })
  end

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

  defp invalid_email_response(conn) do
    conn
    |> put_status(400)
    |> json(%{
      "Message" => "Email not valid or with an unauthorized domain.",
      "ExceptionMessage" => nil,
      "ExceptionStackTrace" => nil,
      "InnerExceptionMessage" => nil,
      "Object" => "error",
      "ValidationErrors" => %{
        "" => [
          "Email not valid or with an unauthorized domain."
        ]
      }
    })
  end
end
