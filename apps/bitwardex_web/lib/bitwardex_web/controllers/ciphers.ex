defmodule BitwardexWeb.CiphersController do
  @moduledoc """
  Controller to handle ciphers
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Core
  alias Bitwardex.Core.Schemas.Cipher

  def create(conn, params) do
    user = BitwardexWeb.Guardian.Plug.current_resource(conn)

    {:ok, cipher} =
      params
      |> Map.put("user_id", user.id)
      |> Core.create_cipher()

    conn
    |> assign(:cipher, cipher)
    |> render("show.json")
  end

  def update(conn, params = %{"id" => id}) do
    user = BitwardexWeb.Guardian.Plug.current_resource(conn)

    case Core.get_cipher(user.id, id) do
      {:ok, %Cipher{} = cipher} ->
        {:ok, %Cipher{} = updated_cipher} = Core.update_cipher(cipher, params)

        conn
        |> assign(:cipher, updated_cipher)
        |> render("show.json")

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
end
