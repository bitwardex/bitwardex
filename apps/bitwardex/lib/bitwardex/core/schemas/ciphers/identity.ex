defmodule Bitwardex.Core.Schemas.Ciphers.Identity do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :address1, :string
    field :address2, :string
    field :address3, :string
    field :city, :string
    field :company, :string
    field :country, :string
    field :email, :string
    field :first_name, :string
    field :middle_name, :string
    field :last_name, :string
    field :license_number, :string
    field :passport_number, :string
    field :phone, :string
    field :postal_code, :string
    field :ssn, :string
    field :state, :string
    field :title, :string
    field :username, :string
  end

  @required_fields []
  @optional_fields [
    :address1,
    :address2,
    :address3,
    :city,
    :company,
    :country,
    :email,
    :first_name,
    :middle_name,
    :last_name,
    :license_number,
    :passport_number,
    :phone,
    :postal_code,
    :ssn,
    :state,
    :title,
    :username
  ]

  @doc false
  def changeset(folder, attrs) do
    folder
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
