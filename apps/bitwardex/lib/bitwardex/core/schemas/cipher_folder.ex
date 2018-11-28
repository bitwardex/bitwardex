defmodule Bitwardex.Core.Schemas.CipherFolder do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  alias Bitwardex.Accounts.Schemas.User
  alias Bitwardex.Core.Schemas.Cipher
  alias Bitwardex.Core.Schemas.Folder

  schema "ciphers_folders" do
    belongs_to(:cipher, Cipher)
    belongs_to(:folder, Folder)
    belongs_to(:user, User)

    timestamps(type: :utc_datetime)
  end

  @required_fields [
    :cipher_id,
    :folder_id,
    :user_id
  ]
  @optional_fields []

  @doc false
  def changeset(cipher, attrs) do
    cipher
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:cipher)
    |> assoc_constraint(:folder)
    |> assoc_constraint(:user)
  end
end
