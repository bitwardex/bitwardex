defmodule Bitwardex.Accounts.Managers.User do
  @moduledoc """
  User-related manager to perform operations on users.
  """

  alias Bitwardex.Repo

  alias Bitwardex.Accounts.Queries.User, as: UserQuery
  alias Bitwardex.Accounts.Schemas.User

  @doc """
  Gets a single user by ID.

  Returns `{:ok, user}` or `{:error, reason }`

  ## Examples

      iex> get_user(123)
      {:ok, %User{}}

      iex> get_user(456)
      {:error, :not_found}

  """
  def get_user(id) do
    User
    |> UserQuery.by_id(id)
    |> Repo.one()
    |> case do
      %User{} = user -> {:ok, user}
      nil -> {:error, :not_found}
    end
  end

  @doc """
  Gets a single user by email address.

  Returns `{:ok, user}` or `{:error, reason }`

  ## Examples

      iex> get_user_by_email("foo@bar.com")
      {:ok, %User{}}

      iex> get_user_by_email("bar@foo.com")
      {:error, :not_found}

  """
  def get_user_by_email(email) do
    User
    |> UserQuery.by_email(email)
    |> Repo.one()
    |> case do
      %User{} = user -> {:ok, user}
      nil -> {:error, :not_found}
    end
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    User
    |> UserQuery.by_id(id)
    |> Repo.one!()
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
