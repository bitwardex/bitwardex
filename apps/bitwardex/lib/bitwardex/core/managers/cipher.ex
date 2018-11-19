defmodule Bitwardex.Core.Managers.Cipher do
  import Ecto.Query, warn: false
  alias Bitwardex.Repo

  alias Bitwardex.Core.Queries.Cipher, as: CipherQuery
  alias Bitwardex.Core.Schemas.Cipher

  def list_ciphers(user_id) do
    Cipher
    |> CipherQuery.by_user(user_id)
    |> Repo.all()
  end

  def get_cipher(user_id, cipher_id) do
    Cipher
    |> CipherQuery.by_user(user_id)
    |> Repo.get(cipher_id)
    |> case do
      %Cipher{} = cipher -> {:ok, cipher}
      nil -> {:error, :not_found}
    end
  end

  def create_cipher(attrs \\ %{}) do
    %Cipher{}
    |> Cipher.changeset(attrs)
    |> Repo.insert()
  end

  def update_cipher(%Cipher{} = cipher, attrs) do
    cipher
    |> Cipher.changeset(attrs)
    |> Repo.update()
  end

  def delete_cipher(%Cipher{} = cipher) do
    Repo.delete(cipher)
  end
end
