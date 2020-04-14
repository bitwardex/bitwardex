defmodule Bitwardex.Accounts.Managers.Organization do
  @moduledoc """
  Organization-related manager to perform operations on users.
  """

  alias Bitwardex.Repo

  alias Bitwardex.Accounts.Queries.Organization, as: OrganizationQuery
  alias Bitwardex.Accounts.Schemas.Organization

  @doc """
  Gets a single organization by ID.

  Returns `{:ok, organization}` or `{:error, reason }`

  ## Examples

      iex> get_organization(123)
      {:ok, %Organization{}}

      iex> get_organization(456)
      {:error, :not_found}

  """
  def get_organization(id) do
    Organization
    |> OrganizationQuery.by_id(id)
    |> Repo.one()
    |> case do
      %Organization{} = org -> {:ok, org}
      nil -> {:error, :not_found}
    end
  end

  @doc """
  Creates an organization.

  ## Examples

      iex> create_organization(%{field: value})
      {:ok, %Organization{}}

      iex> create_organization(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_organization(attrs \\ %{}) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an organization.

  ## Examples

      iex> update_organization(organization, %{field: new_value})
      {:ok, %Organization{}}

      iex> update_organization(organization, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an organization.

  ## Examples

      iex> delete_organization(organization)
      {:ok, %Organization{}}

      iex> delete_organization(organization)
      {:error, %Ecto.Changeset{}}

  """
  def delete_organization(%Organization{} = organization) do
    Repo.delete(organization)
  end
end
