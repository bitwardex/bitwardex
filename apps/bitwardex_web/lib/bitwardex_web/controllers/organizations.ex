defmodule BitwardexWeb.OrganizationsController do
  @moduledoc """
  Controller to handle accounts-related operations
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Core.Accounts

  def create(conn, params) do
    user = BitwardexWeb.Guardian.Plug.current_resource(conn)

    %{
      "key" => user_key,
      "collectionName" => collection_name,
      "name" => name,
      "billingEmail" => billing_email
    } = params

    Accounts.create_organization(
      %{name: name, billing_email: billing_email},
      collection_name,
      user,
      user_key
    )
  end
end
