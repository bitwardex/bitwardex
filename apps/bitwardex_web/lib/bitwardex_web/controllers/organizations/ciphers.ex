defmodule BitwardexWeb.Organizations.CiphersController do
  @moduledoc """
  Controller to handle accounts-related operations
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Core

  def index(conn, %{"organization_id" => organization_id}) do
    ciphers = Core.list_ciphers_by_organization(organization_id)

    json(conn, %{
      "Data" => ciphers,
      "Object" => "list",
      "ContinuationToken" => nil
    })
  end
end
