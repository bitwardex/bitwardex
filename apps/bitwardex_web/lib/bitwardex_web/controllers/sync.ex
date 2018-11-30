defmodule BitwardexWeb.SyncController do
  @moduledoc """
  Controller to handle sync operations
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Core

  alias Bitwardex.Repo

  def sync(conn, params) do
    user =
      conn
      |> BitwardexWeb.Guardian.Plug.current_resource()
      |> Repo.preload(folders: [], confirmed_user_organizations: [:organization])

    collections = Core.get_user_collections(user)

    ciphers = Core.get_user_ciphers(user)

    exclude_domains = Map.get(params, "excludeDomains") == "true"

    conn
    |> assign(:current_user, user)
    |> assign(:ciphers, ciphers)
    |> assign(:collections, collections)
    |> assign(:exclude_domains, exclude_domains)
    |> render("sync.json")
  end
end
