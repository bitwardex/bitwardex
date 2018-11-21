defmodule Bitwardex.Core.Schemas.Ciphers.SecureNote do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :type, :integer
  end

  @required_fields [:type]
  @optional_fields []

  @doc false
  def changeset(folder, attrs) do
    folder
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, _opts) do
      encoded_struct = %{
        "Type" => struct.type
      }

      Jason.encode!(encoded_struct)
    end
  end
end
