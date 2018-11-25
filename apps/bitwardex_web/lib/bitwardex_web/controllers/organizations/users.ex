defmodule BitwardexWeb.Organizations.UsersController do
  @moduledoc """
  Controller to handle accounts-related operations
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Accounts
  alias Bitwardex.Accounts.Schemas.UserOrganization

  alias Bitwardex.Repo

  def index(conn, %{"organization_id" => organization_id}) do
    case Accounts.get_organization(organization_id) do
      {:ok, organization} ->
        users =
          organization
          |> Repo.preload(organization_users: [:user])
          |> Map.get(:organization_users)
          |> Enum.map(&encode_organization_user_details/1)

        json(conn, %{
          "Data" => users,
          "Object" => "list",
          "ContinuationToken" => nil
        })

      {:error, _err} ->
        resp(conn, 500, "")
    end
  end

  defp encode_organization_user_details(%UserOrganization{} = org_user) do
    %{
      "Id" => org_user.user.id,
      "UserId" => org_user.id,
      "Name" => org_user.user.name,
      "Email" => org_user.user.email,
      "Type" => org_user.type,
      "Status" => org_user.status,
      "AccessAll" => org_user.access_all,
      "Object" => "organizationUserUserDetails"
    }
  end
end
