defmodule BitwardexWeb.CiphersController do
  @moduledoc """
  Controller to handle ciphers
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Core
  alias Bitwardex.Core.Schemas.Cipher
  alias Bitwardex.Repo

  def create(conn, params) do
    user = BitwardexWeb.Guardian.Plug.current_resource(conn)

    data =
      with {:ok, cipher_data} <- Map.fetch(params, "cipher"),
           collection_ids <- Map.get(params, "collection_ids", []) do
        Map.put(cipher_data, "collection_ids", collection_ids)
      else
        _ -> params
      end

    {:ok, cipher} =
      data
      |> Map.put("user_id", user.id)
      |> Core.create_cipher()

    json(conn, cipher)
  end

  def show(conn, %{"id" => id}) do
    case Core.get_cipher(id) do
      {:ok, %Cipher{} = cipher} ->
        json(conn, cipher)

      _err ->
        resp(conn, 404, "")
    end
  end

  def update(conn, %{"id" => id} = params) do
    case Core.get_cipher(id) do
      {:ok, %Cipher{} = cipher} ->
        {:ok, %Cipher{} = updated_cipher} = Core.update_cipher(cipher, params)

        json(conn, updated_cipher)

      _err ->
        resp(conn, 404, "")
    end
  end

  def update_collections(conn, %{"id" => id, "collection_ids" => collection_ids}) do
    case Core.get_cipher(id) do
      {:ok, %Cipher{} = cipher} ->
        attrs = %{"collection_ids" => collection_ids}
        {:ok, %Cipher{} = updated_cipher} = Core.update_cipher(cipher, attrs)

        json(conn, updated_cipher)

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

  def purge(conn, params) do
    user =
      conn
      |> BitwardexWeb.Guardian.Plug.current_resource()
      |> Repo.preload([:ciphers, :folders])

    if user.master_password_hash == Map.get(params, "masterPasswordHash") do
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
