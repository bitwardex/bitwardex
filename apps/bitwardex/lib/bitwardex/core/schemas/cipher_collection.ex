defmodule Bitwardex.Core.Schemas.CipherCollection do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  alias Bitwardex.Core.Schemas.Cipher
  alias Bitwardex.Core.Schemas.Collection

  schema "ciphers_collections" do
    belongs_to(:cipher, Cipher)
    belongs_to(:collection, Collection)

    timestamps(type: :utc_datetime)
  end

  @required_fields [
    :cipher_id,
    :collection_id
  ]
  @optional_fields []

  @doc false
  def changeset(cipher, attrs) do
    cipher
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:cipher)
    |> assoc_constraint(:collection)
  end
end
