defmodule BitwardexWeb.SyncController do
  @moduledoc """
  Controller to handle sync operations
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Repo

  def sync(conn, params) do
    user =
      conn
      |> BitwardexWeb.Guardian.Plug.current_resource()
      |> Repo.preload(:folders)

    exclude_domains = Map.get(params, "excludeDomains") == "true"

    conn
    |> assign(:current_user, user)
    |> assign(:exclude_domains, exclude_domains)
    |> render("sync.json")
  end
end
