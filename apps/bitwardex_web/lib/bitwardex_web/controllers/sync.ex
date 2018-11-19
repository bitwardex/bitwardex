defmodule BitwardexWeb.SyncController do
  @moduledoc """
  Controller to handle sync operations
  """

  use BitwardexWeb, :controller

  def sync(conn, _params) do
    user = BitwardexWeb.Guardian.Plug.current_resource(conn)

    conn
    |> assign(:current_user, user)
    |> render("sync.json")
  end
end
