defmodule BitwardexWeb.FoldersController do
  @moduledoc """
  Controller to handle accounts-related operations
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Core
  alias Bitwardex.Core.Schemas.Folder

  def create(conn, %{"name" => name}) do
    user = BitwardexWeb.Guardian.Plug.current_resource(conn)

    {:ok, %Folder{} = folder} = Core.create_folder(%{name: name, user_id: user.id})

    json(conn, folder)
  end

  def update(conn, %{"id" => id, "name" => name}) do
    user = BitwardexWeb.Guardian.Plug.current_resource(conn)

    case Core.get_folder(user.id, id) do
      {:ok, %Folder{} = folder} ->
        {:ok, %Folder{} = updated_folder} = Core.update_folder(folder, %{name: name})

        json(conn, updated_folder)

      _err ->
        resp(conn, 404, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    user = BitwardexWeb.Guardian.Plug.current_resource(conn)

    case Core.get_folder(user.id, id) do
      {:ok, %Folder{} = folder} ->
        {:ok, %Folder{}} = Core.delete_folder(folder)
        resp(conn, 200, "")

      _err ->
        resp(conn, 404, "")
    end
  end
end
