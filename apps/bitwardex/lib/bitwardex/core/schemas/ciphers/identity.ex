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

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, _opts) do
      encoded_struct = %{
        "Address1" => struct.address1,
        "Address2" => struct.address2,
        "Address3" => struct.address3,
        "City" => struct.city,
        "Company" => struct.company,
        "Country" => struct.country,
        "Email" => struct.email,
        "FirstName" => struct.first_name,
        "MiddleName" => struct.middle_name,
        "LastName" => struct.last_name,
        "LicenseNumber" => struct.license_number,
        "PassportNumber" => struct.passport_number,
        "Phone" => struct.phone,
        "PostalCode" => struct.postal_code,
        "SSN" => struct.ssn,
        "State" => struct.state,
        "Title" => struct.title,
        "Username" => struct.username
      }

      Jason.encode!(encoded_struct)
    end
  end
end
