defmodule Bitwardex.Core.Managers.Cipher do
  import Ecto.Query, warn: false

  alias Bitwardex.Repo

  alias Bitwardex.Accounts.Schemas.User

  alias Bitwardex.Core
  alias Bitwardex.Core.Queries.Cipher, as: CipherQuery
  alias Bitwardex.Core.Schemas.Cipher
  alias Bitwardex.Core.Schemas.Collection

  def list_ciphers_by_user(user_id) do
    Cipher
    |> CipherQuery.by_user(user_id)
    |> CipherQuery.preload_collections()
    |> Repo.all()
  end

  def list_ciphers_by_organization(organization_id) do
    Cipher
    |> CipherQuery.by_organization(organization_id)
    |> CipherQuery.preload_collections()
    |> Repo.all()
  end

  def get_cipher(cipher_id) do
    Cipher
    |> CipherQuery.preload_collections()
    |> Repo.get(cipher_id)
    |> case do
      %Cipher{} = cipher -> {:ok, cipher}
      nil -> {:error, :not_found}
    end
  end

  def create_cipher(%User{} = user, attrs) do
    changeset = Cipher.changeset_create(%Cipher{}, attrs)

    cipher_changeset =
      with org_id <- Ecto.Changeset.get_field(changeset, :organization_id),
           false <- org_id in [nil, ""] do
        parse_collections_data(changeset, attrs)
      else
        _ -> Cipher.changeset_create(changeset, %{user_id: user.id})
      end

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:cipher, cipher_changeset)
    |> Ecto.Multi.run(:cipher_folder, fn _multi, %{cipher: cipher} ->
      case Map.fetch(attrs, "folder_id") do
        {:ok, folder_id} when folder_id in [nil, ""] -> Core.delete_cipher_folder(cipher, user)
        {:ok, folder_id} -> Core.insert_or_update_cipher_folder(cipher, user, folder_id)
        _ -> {:ok, nil}
      end
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{cipher: cipher}} -> {:ok, cipher}
      {:error, err} -> {:error, err}
    end
  end

  def update_cipher(%Cipher{} = cipher, %User{} = user, attrs) do
    changeset = Cipher.changeset_update(cipher, attrs)

    cipher_changeset =
      with org_id <- Ecto.Changeset.get_field(changeset, :organization_id),
           false <- org_id in [nil, ""] do
        parse_collections_data(changeset, attrs)
      else
        _ -> changeset
      end

    Ecto.Multi.new()
    |> Ecto.Multi.update(:cipher, cipher_changeset)
    |> Ecto.Multi.run(:cipher_folder, fn _multi, %{cipher: cipher} ->
      case Map.fetch(attrs, "folder_id") do
        {:ok, folder_id} when folder_id in [nil, ""] -> Core.delete_cipher_folder(cipher, user)
        {:ok, folder_id} -> Core.insert_or_update_cipher_folder(cipher, user, folder_id)
        _ -> {:ok, nil}
      end
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{cipher: cipher}} -> {:ok, cipher}
      {:error, err} -> {:error, err}
    end
  end

  def delete_cipher(%Cipher{} = cipher) do
    Repo.delete(cipher)
  end

  defp parse_collections_data(changeset, attrs) do
    case Map.fetch(attrs, "collection_ids") do
      {:ok, collection_ids} when is_list(collection_ids) ->
        collections =
          Collection
          |> where([c], c.id in ^collection_ids)
          |> Repo.all()

        Ecto.Changeset.put_assoc(changeset, :collections, collections)

      _ ->
        changeset
    end
  end
end
