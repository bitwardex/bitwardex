defmodule BitwardexWeb.NotificationsController do
  @moduledoc """
  Controller to handle accounts-related operations
  """

  use BitwardexWeb, :controller

  def negotiate(conn, _params) do
    connection_id = Ecto.UUID.generate()

    conn
    |> assign(:connection_id, connection_id)
    |> render("negotiate.json")
  end

  def hub(conn, _params) do
    redirect(conn, to: "/notifications/hub/websocket")
  end
end
