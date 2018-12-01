defmodule BitwardexWeb.Organizations.UsersController do
  @moduledoc """
  Controller to handle accounts-related operations
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Accounts
  alias Bitwardex.Core

  alias Bitwardex.Repo

  alias BitwardexWeb.Emails
  alias BitwardexWeb.Mailer
  alias BitwardexWeb.Organizations.UsersView

  def index(conn, %{"organization_id" => organization_id}) do
    case Accounts.get_organization(organization_id) do
      {:ok, organization} ->
        users =
          organization
          |> Repo.preload(organization_users: [:user])
          |> Map.get(:organization_users)
          |> Enum.map(
            &UsersView.render("user_organization_details.json", %{user_organization: &1})
          )

        json(conn, %{
          "Data" => users,
          "Object" => "list",
          "ContinuationToken" => nil
        })

      {:error, _err} ->
        resp(conn, 500, "")
    end
  end

  def show(conn, %{"organization_id" => organization_id, "id" => id}) do
    with {:ok, organization} <- Accounts.get_organization(organization_id),
         {:ok, user_org} <- Accounts.get_user_organization(organization, id) do
      preloaded_user_org = Repo.preload(user_org, [:user_collections])

      conn
      |> assign(:user_organization, preloaded_user_org)
      |> render("user_organization.json")
    else
      _ ->
        resp(conn, 404, "")
    end
  end

  def update(
        conn,
        %{
          "organization_id" => organization_id,
          "id" => id,
          "access_all" => access_all,
          "type" => type
        } = params
      ) do
    with {:ok, organization} <- Accounts.get_organization(organization_id),
         {:ok, user_org} <- Accounts.get_user_organization(organization, id) do
      collections = Map.get(params, "collections") || []

      collections_data =
        Enum.map(collections, fn %{"id" => id, "read_only" => read_only} ->
          %{id: id, read_only: read_only}
        end)

      {:ok, updated_user_org} =
        Accounts.update_user_organization(user_org, %{type: type, access_all: access_all})

      {:ok, _updated_org_user} = Core.update_user_collections(updated_user_org, collections_data)

      resp(conn, 200, "")
    else
      _ ->
        resp(conn, 404, "")
    end
  end

  def invite(
        conn,
        %{
          "organization_id" => organization_id,
          "emails" => emails,
          "access_all" => access_all,
          "type" => type
        } = params
      ) do
    case Accounts.get_organization(organization_id) do
      {:ok, organization} ->
        collections = Map.get(params, "collections") || []

        invites =
          Enum.map(emails, fn email ->
            Accounts.invite_organization_user(organization, email, type, access_all, collections)
          end)

        Enum.each(invites, fn
          {:ok, user, user_org} ->
            user
            |> Emails.organization_invite_email(organization, user_org)
            |> Mailer.deliver_now()

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
         true <- user_org.status == 0,
         {:ok, user} <- Accounts.get_user(user_org.user_id) do
      user
      |> Emails.organization_invite_email(organization, user_org)
      |> Mailer.deliver_now()

      resp(conn, 200, "")
    else
      _ ->
        resp(conn, 404, "")
    end
  end

  def accept(conn, %{"organization_id" => organization_id, "id" => id, "token" => token}) do
    with {:ok, organization} <- Accounts.get_organization(organization_id),
         {:ok, user_org} <- Accounts.get_user_organization(organization, id),
         true <- user_org.status == 0,
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
         true <- user_org.status == 1,
         {:ok, user} <- Accounts.get_user(user_org.user_id),
         {:ok, _updated_user_org} <-
           Accounts.update_user_organization(user_org, %{status: 2, key: key}) do
      user
      |> Emails.organization_confirm_email(organization)
      |> Mailer.deliver_now()

      resp(conn, 200, "")
    else
      _ ->
        resp(conn, 404, "")
    end
  end

  def delete(conn, %{"organization_id" => organization_id, "id" => id}) do
    with {:ok, organization} <- Accounts.get_organization(organization_id),
         {:ok, user_organization} <- Accounts.get_user_organization(organization, id) do
      {:ok, _} = Repo.delete(user_organization)
      resp(conn, 200, "")
    else
      _ ->
        resp(conn, 404, "")
    end
  end
end
