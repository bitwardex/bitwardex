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

  def create_cipher(%{"organization_id" => org_id} = attrs)
      when org_id != "" and not is_nil(org_id) do
    collection_ids = Map.get(attrs, "collection_ids", [])

    collections =
      Collection
      |> where([c], c.id in ^collection_ids)
      |> Repo.all()

    updated_attrs =
      attrs
      |> Map.delete("user_id")

    %Cipher{}
    |> Cipher.changeset(updated_attrs)
    |> Ecto.Changeset.put_assoc(:collections, collections)
    |> Repo.insert()
  end

  def create_cipher(attrs) do
    updated_attrs =
      attrs
      |> Map.delete("organization_id")

    %Cipher{}
    |> Cipher.changeset(updated_attrs)
    |> Repo.insert()
  end

  def update_cipher(%Cipher{organization_id: nil} = cipher, attrs) do
    cipher
    |> Cipher.changeset(attrs)
    |> Repo.update()
  end

  def update_cipher(%Cipher{user_id: nil} = cipher, attrs) do
    case Map.fetch(attrs, "collection_ids") do
      {:ok, collection_ids} when is_list(collection_ids) ->
        collections =
          Collection
          |> where([c], c.id in ^collection_ids)
          |> Repo.all()

        cipher
        |> Cipher.changeset(attrs)
        |> Ecto.Changeset.put_assoc(:collections, collections)

      _ ->
        Cipher.changeset(cipher, attrs)
    end
    |> Repo.update()
  end

  def delete_cipher(%Cipher{} = cipher) do
    Repo.delete(cipher)
  end
end
