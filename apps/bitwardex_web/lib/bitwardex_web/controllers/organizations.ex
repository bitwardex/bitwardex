defmodule BitwardexWeb.OrganizationsController do
  @moduledoc """
  Controller to handle accounts-related operations
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Accounts

  def create(conn, params) do
    user = BitwardexWeb.Guardian.Plug.current_resource(conn)

    case Accounts.create_organization(params, user) do
      {:ok, %{organization: organization}} -> json(conn, organization)
      {:error, _step, _changeset, _changes_so_far} -> nil
    end
  end
end
