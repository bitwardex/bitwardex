defmodule BitwardexWeb.OrganizationsController do
  @moduledoc """
  Controller to handle accounts-related operations
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Accounts

  def create(conn, params) do
    IO.inspect(params)
    user = BitwardexWeb.Guardian.Plug.current_resource(conn)

    Accounts.create_organization(params, user)
  end
end
