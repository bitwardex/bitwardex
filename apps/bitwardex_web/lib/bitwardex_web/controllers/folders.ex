defmodule BitwardexWeb.FoldersController do
  @moduledoc """
  Controller to handle accounts-related operations
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Core
  alias Bitwardex.Core.Schemas.Folder

  def create(conn, %{"name" => name}) do
    user = current_user(conn)

    {:ok, %Folder{} = folder} = Core.create_folder(%{name: name, user_id: user.id})

    conn
    |> assign(:folder, folder)
    |> render("folder.json")
  end

  def update(conn, %{"id" => id, "name" => name}) do
    user = current_user(conn)

    case Core.get_folder(user.id, id) do
      {:ok, %Folder{} = folder} ->
        {:ok, %Folder{} = updated_folder} = Core.update_folder(folder, %{name: name})

        conn
        |> assign(:folder, updated_folder)
        |> render("folder.json")

      _err ->
        resp(conn, 404, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    user = current_user(conn)

    case Core.get_folder(user.id, id) do
      {:ok, %Folder{} = folder} ->
        {:ok, %Folder{}} = Core.delete_folder(folder)
        resp(conn, 200, "")

      _err ->
        resp(conn, 404, "")
    end
  end
end
