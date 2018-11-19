defmodule Bitwardex.Core.Schemas.Field do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :name, :string
    field :value, :string
    field :type, :integer
  end

  @required_field [:name, :value, :type]
  @optional_fields []

  @doc false
  def changeset(field, attrs) do
    field
    |> cast(attrs, @required_field ++ @optional_fields)
    |> validate_required(@required_field)
  end
end
