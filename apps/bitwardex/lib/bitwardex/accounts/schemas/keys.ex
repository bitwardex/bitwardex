defmodule Bitwardex.Accounts.Schemas.Keys do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :encrypted_private_key, :string
    field :public_key, :string
  end

  @required_fields [:encrypted_private_key, :public_key]
  @optional_fields []

  @doc false
  def changeset(keys, attrs) do
    keys
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, _opts) do
      encoded_struct = %{
        "EncryptedPrivateKey" => struct.encrypted_private_key,
        "PublicKey" => struct.public_key
      }

      Jason.encode!(encoded_struct)
    end
  end
end
