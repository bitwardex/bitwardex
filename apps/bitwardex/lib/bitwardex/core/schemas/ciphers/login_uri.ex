defmodule Bitwardex.Core.Schemas.Ciphers.LoginUri do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :match, :integer
    field :uri, :string
  end

  @required_fields []
  @optional_fields [
    :match,
    :uri
  ]

  @doc false
  def changeset(folder, attrs) do
    folder
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, _opts) do
      encoded_struct = %{
        "Match" => struct.match,
        "Uri" => struct.uri
      }

      Jason.encode!(encoded_struct)
    end
  end
end
