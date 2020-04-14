defmodule BitwardexWeb.OrganizationsController do
  @moduledoc """
  Controller to handle accounts-related operations
  """

  use BitwardexWeb, :controller

  alias Bitwardex.Accounts

  def create(conn, params) do
    user = current_user(conn)

    case Accounts.create_organization(params, user) do
      {:ok, %{organization: organization}} ->
        json(conn, organization)

      {:error, :not_allowed} ->
        conn
        |> put_status(500)
        |> json(%{
          "Message" => "The model state is invalid.",
          "ValidationErrors" => %{"" => ["Organization creation is not allowed"]},
          "ExceptionMessage" => nil,
          "ExceptionStackTrace" => nil,
          "InnerExceptionMessage" => nil,
          "Object" => "error"
        })

      {:error, _step, _changeset, _changes_so_far} ->
        resp(conn, 500, "")
    end
  end

  def show(conn, %{"id" => id}) do
    case Accounts.get_organization(id) do
      {:ok, organization} -> json(conn, organization)
      {:error, _err} -> resp(conn, 404, "")
    end
  end

  def update(conn, %{"id" => id} = params) do
    case Accounts.get_organization(id) do
      {:ok, organization} ->
        {:ok, updated_organization} = Accounts.update_organization(organization, params)

        json(conn, updated_organization)

      {:error, _err} ->
        resp(conn, 404, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    case Accounts.get_organization(id) do
      {:ok, organization} ->
        {:ok, _org} = Accounts.delete_organization(organization)
        resp(conn, 200, "")

      {:error, _err} ->
        resp(conn, 404, "")
    end
  end
end
