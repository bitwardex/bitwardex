defmodule Bitwardex.Core.Managers.Folder do
  @moduledoc """
  The Core context.
  """

  import Ecto.Query, warn: false
  alias Bitwardex.Repo

  alias Bitwardex.Core.Queries.Folder, as: FolderQuery
  alias Bitwardex.Core.Schemas.Folder

  @doc """
  Returns the list of folders.

  ## Examples

      iex> list_folders()
      [%Folder{}, ...]

  """
  def list_folders(user_id) do
    Folder
    |> FolderQuery.by_user(user_id)
    |> Repo.all()
  end

  @doc """
  Gets a single folder.

  Raises `Ecto.NoResultsError` if the Folder does not exist.

  ## Examples

      iex> get_folder(user_id, 123)
      {:ok, %Folder{}}

      iex> get_folder(user_id, 456)
      {:error, :not_found}

  """
  def get_folder(user_id, id) do
    Folder
    |> FolderQuery.by_user(user_id)
    |> Repo.get(id)
    |> case do
      %Folder{} = folder -> {:ok, folder}
      nil -> {:error, :not_found}
    end
  end

  @doc """
  Creates a folder.

  ## Examples

      iex> create_folder(%{field: value})
      {:ok, %Folder{}}

      iex> create_folder(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_folder(attrs \\ %{}) do
    %Folder{}
    |> Folder.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a folder.

  ## Examples

      iex> update_folder(folder, %{field: new_value})
      {:ok, %Folder{}}

      iex> update_folder(folder, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_folder(%Folder{} = folder, attrs) do
    folder
    |> Folder.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Folder.

  ## Examples

      iex> delete_folder(folder)
      {:ok, %Folder{}}

      iex> delete_folder(folder)
      {:error, %Ecto.Changeset{}}

  """
  def delete_folder(%Folder{} = folder) do
    Repo.delete(folder)
  end
end
