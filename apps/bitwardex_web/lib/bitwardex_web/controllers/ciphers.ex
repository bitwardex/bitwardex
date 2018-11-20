defmodule BitwardexWeb.CiphersController do
  @moduledoc """
  Controller to handle ciphers
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Core
  alias Bitwardex.Core.Schemas.Cipher

  def create(conn, params) do
    user = BitwardexWeb.Guardian.Plug.current_resource(conn)

    parsed_params = parse_params(params)

    {:ok, cipher} =
      parsed_params
      |> Map.put("user_id", user.id)
      |> Core.create_cipher()

    json(conn, cipher)
  end

  def update(conn, params = %{"id" => id}) do
    user = BitwardexWeb.Guardian.Plug.current_resource(conn)

    parsed_params = parse_params(params)

    case Core.get_cipher(user.id, id) do
      {:ok, %Cipher{} = cipher} ->
        {:ok, %Cipher{} = updated_cipher} = Core.update_cipher(cipher, parsed_params)

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

  defp parse_params(params) do
    params
    |> Enum.map(fn {key, value} ->
      {Macro.underscore(key), value}
    end)
    |> Enum.into(%{})
  end
end
