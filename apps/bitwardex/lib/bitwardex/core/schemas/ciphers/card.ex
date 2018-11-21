defmodule Bitwardex.Core.Schemas.Ciphers.Card do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :brand, :string
    field :cardholder_name, :string
    field :code, :string
    field :exp_month, :string
    field :exp_year, :string
    field :number, :string
  end

  @required_fields []
  @optional_fields [
    :brand,
    :cardholder_name,
    :code,
    :exp_month,
    :exp_year,
    :number
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
        "Brand" => struct.brand,
        "CardholderName" => struct.cardholder_name,
        "Code" => struct.code,
        "ExpMonth" => struct.exp_month,
        "ExpYear" => struct.exp_year,
        "Number" => struct.number
      }

      Jason.encode!(encoded_struct)
    end
  end
end
