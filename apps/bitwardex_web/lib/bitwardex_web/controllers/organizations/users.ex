defmodule BitwardexWeb.Organizations.UsersController do
  @moduledoc """
  Controller to handle accounts-related operations
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Accounts
  alias Bitwardex.Accounts.Schemas.UserOrganization

  alias Bitwardex.Repo

  alias BitwardexWeb.Emails
  alias BitwardexWeb.Mailer

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

  def invite(
        conn,
        %{
          "organization_id" => organization_id,
          "emails" => emails,
          "access_all" => access_all,
          "collections" => collections,
          "type" => type
        }
      ) do
    case Accounts.get_organization(organization_id) do
      {:ok, organization} ->
        invites =
          Enum.map(emails, fn email ->
            Accounts.invite_organization_user(organization, email, type, access_all, collections)
          end)

        Enum.each(invites, fn
          {:ok, user, user_org} ->
            Emails.invite_email(user, organization, user_org) |> Mailer.deliver_now()

          _ ->
            nil
        end)

        invites
        |> Enum.all?(fn result -> elem(result, 0) == :ok end)
        |> case do
          true -> resp(conn, 200, "")
          false -> resp(conn, 500, "")
        end

      {:error, _err} ->
        resp(conn, 500, "")
    end
  end

  def reinvite(conn, %{"organization_id" => organization_id, "id" => id}) do
    with {:ok, organization} <- Accounts.get_organization(organization_id),
         {:ok, user_org} <- Accounts.get_user_organization(organization, id),
         {:ok, user} <- Accounts.get_user(user_org.user_id) do
      Emails.invite_email(user, organization, user_org) |> Mailer.deliver_now()
      resp(conn, 200, "")
    else
      _ ->
        resp(conn, 404, "")
    end
  end

  def accept(conn, %{"organization_id" => organization_id, "id" => id, "token" => token}) do
    with {:ok, organization} <- Accounts.get_organization(organization_id),
         {:ok, user_org} <- Accounts.get_user_organization(organization, id),
         true <- token == user_org.invite_token,
         {:ok, _updated_user_org} <- Accounts.update_user_organization(user_org, %{status: 1}) do
      resp(conn, 200, "")
    else
      _ ->
        resp(conn, 404, "")
    end
  end

  def confirm(conn, %{"organization_id" => organization_id, "id" => id, "key" => key}) do
    with {:ok, organization} <- Accounts.get_organization(organization_id),
         {:ok, user_org} <- Accounts.get_user_organization(organization, id),
         {:ok, _updated_user_org} <-
           Accounts.update_user_organization(user_org, %{status: 2, key: key}) do
      resp(conn, 200, "")
    else
      _ ->
        resp(conn, 404, "")
    end
  end

  def delete(conn, %{"organization_id" => organization_id, "id" => id}) do
    with {:ok, organization} <- Accounts.get_organization(organization_id),
         {:ok, user} <- Accounts.get_user(id),
         {:ok, user_organization} <- Accounts.get_user_organization(organization, user) do
      {:ok, _} = Repo.delete(user_organization)
      resp(conn, 200, "")
    else
      _ ->
        resp(conn, 404, "")
    end
  end

  defp encode_organization_user_details(%UserOrganization{} = org_user) do
    %{
      "Id" => org_user.id,
      "UserId" => org_user.user.id,
      "Name" => org_user.user.name,
      "Email" => org_user.user.email,
      "Type" => org_user.type,
      "Status" => org_user.status,
      "AccessAll" => org_user.access_all,
      "Object" => "organizationUserUserDetails"
    }
  end
end
