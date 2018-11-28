defmodule Bitwardex.Core.Managers.Cipher do
  import Ecto.Query, warn: false

  alias Bitwardex.Repo

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

  def create_cipher(attrs) do
    changeset = Cipher.changeset_create(%Cipher{}, attrs)

    with org_id <- Ecto.Changeset.get_field(changeset, :organization_id),
         false <- is_nil(org_id),
         false <- org_id != "" do
      parse_collections_data(changeset, attrs)
    else
      _ -> changeset
    end
    |> Repo.insert()
  end

  def update_cipher(%Cipher{} = cipher, attrs) do
    changeset = Cipher.changeset_update(cipher, attrs)

    with org_id <- Ecto.Changeset.get_field(changeset, :organization_id),
         false <- is_nil(org_id),
         false <- org_id != "" do
      parse_collections_data(changeset, attrs)
    else
      _ -> changeset
    end
    |> Repo.update()
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
