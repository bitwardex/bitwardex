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

    {:ok, cipher} =
      params
      |> Map.put("user_id", user.id)
      |> Core.create_cipher()

    json(conn, cipher)
  end

  def update(conn, %{"id" => id} = params) do
    user = BitwardexWeb.Guardian.Plug.current_resource(conn)

    case Core.get_cipher(user.id, id) do
      {:ok, %Cipher{} = cipher} ->
        {:ok, %Cipher{} = updated_cipher} = Core.update_cipher(cipher, params)

        json(conn, updated_cipher)

      _err ->
        resp(conn, 404, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    user = BitwardexWeb.Guardian.Plug.current_resource(conn)

    case Core.get_cipher(user.id, id) do
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
