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
end
