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
      {:error, _step, _changeset, _changes_so_far} -> resp(conn, 500, "")
    end
  end

  def show(conn, %{"organization_id" => id}) do
    case Accounts.get_organization(id) do
      {:ok, organization} -> json(conn, organization)
      {:error, _err} -> resp(conn, 404, "")
    end
  end
end
