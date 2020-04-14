defmodule BitwardexWeb.Organizations.CiphersController do
  @moduledoc """
  Controller to handle accounts-related operations
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Core

  alias BitwardexWeb.CiphersView

  def index(conn, %{"organization_id" => organization_id}) do
    user = current_user(conn)

    ciphers_json =
      organization_id
      |> Core.list_ciphers_by_organization()
      |> Enum.map(fn cipher ->
        CiphersView.render("cipher.json", %{current_user: user, cipher: cipher})
      end)

    json(conn, %{
      "Data" => ciphers_json,
      "Object" => "list",
      "ContinuationToken" => nil
    })
  end
end
