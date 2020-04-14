defmodule BitwardexWeb.CiphersController do
  @moduledoc """
  Controller to handle ciphers
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Accounts
  alias Bitwardex.Core
  alias Bitwardex.Core.Schemas.Cipher
  alias Bitwardex.Repo

  def create(conn, params) do
    user = current_user(conn)

    # Clean organisation cipher save request
    data =
      with {:ok, cipher_data} <- Map.fetch(params, "cipher"),
           collection_ids <- Map.get(params, "collection_ids", []) do
        Map.put(cipher_data, "collection_ids", collection_ids)
      else
        _ -> params
      end

    # Clean empty fields issue
    data = Map.put(data, "fields", Map.get(data, "fields") || [])

    # Clean empty URIs issue
    data =
      with {:ok, login_data} <- Map.fetch(data, "login") do
        uris = Map.get(login_data, "uris") || []
        updated_login_data = Map.put(login_data, "uris", uris)
        Map.put(data, "login", updated_login_data)
      else
        _ -> data
      end

    with {:ok, cipher} <- Core.create_cipher(user, data) do
      preloaded_cipher = Repo.preload(cipher, [:collections])

      conn
      |> assign(:cipher, preloaded_cipher)
      |> render("cipher.json")
    end
  end

  def show(conn, %{"id" => id}) do
    case Core.get_cipher(id) do
      {:ok, %Cipher{} = cipher} ->
        conn
        |> assign(:cipher, cipher)
        |> render("cipher.json")

      _err ->
        resp(conn, 404, "")
    end
  end

  def update(conn, %{"id" => id} = params) do
    user = current_user(conn)

    sanitized_params =
      case Map.get(params, "fields") do
        folders when is_list(folders) -> params
        _ -> Map.delete(params, "fields")
      end

    case Core.get_cipher(id) do
      {:ok, %Cipher{} = cipher} ->
        {:ok, %Cipher{} = updated_cipher} = Core.update_cipher(cipher, user, sanitized_params)

        conn
        |> assign(:cipher, updated_cipher)
        |> render("cipher.json")

      _err ->
        resp(conn, 404, "")
    end
  end

  def update_collections(conn, %{"id" => id, "collection_ids" => collection_ids}) do
    user = current_user(conn)

    case Core.get_cipher(id) do
      {:ok, %Cipher{} = cipher} ->
        {:ok, %Cipher{} = updated_cipher} =
          Core.update_cipher(cipher, user, %{"collection_ids" => collection_ids})

        conn
        |> assign(:cipher, updated_cipher)
        |> render("cipher.json")

      _err ->
        resp(conn, 404, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    case Core.get_cipher(id) do
      {:ok, %Cipher{} = cipher} ->
        {:ok, %Cipher{}} = Core.delete_cipher(cipher)
        resp(conn, 200, "")

      _err ->
        resp(conn, 404, "")
    end
  end

  def purge(conn, %{"organization_id" => organization_id} = params) do
    user = current_user(conn)

    {:ok, organization} = Accounts.get_organization(organization_id)

    if user.master_password_hash == Map.get(params, "master_password_hash") do
      organization
      |> Repo.preload(:ciphers)
      |> Map.get(:ciphers)
      |> Enum.each(&Core.delete_cipher/1)

      resp(conn, 200, "")
    else
      conn
      |> put_status(400)
      |> json(%{
        "ValidationErrors" => %{
          "MasterPasswordHash" => [
            "Invalid password."
          ]
        },
        "Object" => "error"
      })
    end
  end

  def purge(conn, params) do
    user =
      conn
      |> current_user()
      |> Repo.preload([:ciphers, :folders])

    if user.master_password_hash == Map.get(params, "master_password_hash") do
      Enum.each(user.ciphers, &Core.delete_cipher/1)
      Enum.each(user.folders, &Core.delete_folder/1)
      resp(conn, 200, "")
    else
      conn
      |> put_status(400)
      |> json(%{
        "ValidationErrors" => %{
          "MasterPasswordHash" => [
            "Invalid password."
          ]
        },
        "Object" => "error"
      })
    end
  end
end
