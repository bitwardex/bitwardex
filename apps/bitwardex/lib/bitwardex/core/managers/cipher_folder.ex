defmodule Bitwardex.Core.Managers.CipherFolder do
  import Ecto.Query, warn: false

  alias Bitwardex.Repo

  alias Bitwardex.Accounts.Schemas.User
  alias Bitwardex.Core.Schemas.Cipher
  alias Bitwardex.Core.Schemas.CipherFolder

  def get_cipher_folder(%Cipher{} = cipher, %User{} = user) do
    cipher_folder = Repo.get_by(CipherFolder, cipher_id: cipher.id, user_id: user.id)

    case cipher_folder do
      %CipherFolder{} = cipher_folder -> {:ok, cipher_folder}
      nil -> {:error, :not_found}
    end
  end

  def insert_or_update_cipher_folder(%Cipher{} = cipher, %User{} = user, folder_id) do
    cipher_folder = Repo.get_by(CipherFolder, cipher_id: cipher.id, user_id: user.id)

    case cipher_folder do
      %CipherFolder{} = cipher_folder -> cipher_folder
      nil -> %CipherFolder{}
    end
    |> CipherFolder.changeset(%{cipher_id: cipher.id, user_id: user.id, folder_id: folder_id})
    |> Repo.insert_or_update()
  end

  def delete_cipher_folder(%Cipher{} = cipher, %User{} = user) do
    cipher_folder = Repo.get_by(CipherFolder, cipher_id: cipher.id, user_id: user.id)

    with %CipherFolder{} <- cipher_folder,
         {:ok, cipher_folder} <- Repo.delete(cipher_folder) do
      {:ok, cipher_folder}
    else
      nil -> {:ok, cipher_folder}
      {:error, err} -> {:error, err}
    end
  end
end
