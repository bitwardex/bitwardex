defmodule Bitwardex.Accounts.Schemas.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bitwardex.Accounts.Schemas.UserOrganization
  alias Bitwardex.Core.Schemas.Cipher
  alias Bitwardex.Core.Schemas.Collection

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "organizations" do
    field :billing_email, :string
    field :name, :string

    field :business_name, :string
    field :business_address1, :string
    field :business_address2, :string
    field :business_address3, :string
    field :business_country, :string
    field :business_tax_number, :string

    has_many :organization_users, UserOrganization
    has_many :users, through: [:organization_users, :user]

    has_many :collections, Collection
    has_many :ciphers, Cipher

    timestamps(type: :utc_datetime)
  end

  @required_fields [:name, :billing_email]
  @optional_fields [
    :business_name,
    :business_address1,
    :business_address2,
    :business_address3,
    :business_country,
    :business_tax_number
  ]

  @email_regex ~r/^[A-Za-z0-9._%+-\\']+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_format(:billing_email, @email_regex)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, _opts) do
      encoded_struct = %{
        "Id" => struct.id,
        "Name" => struct.name,
        "BusinessName" => struct.business_name,
        "BusinessAddress1" => struct.business_address1,
        "BusinessAddress2" => struct.business_address2,
        "BusinessAddress3" => struct.business_address3,
        "BusinessCountry" => struct.business_country,
        "BusinessTaxNumber" => struct.business_tax_number,
        "BillingEmail" => struct.billing_email,

        # Organization-hardcoded values
        # TODO: Move this to the organization schema to persist it in DB
        "Plan" => "TeamsAnnually",
        "PlanType" => 5,
        "UsersGetPremium" => true,
        "Seats" => 1000,
        "MaxCollections" => 1000,
        # The value doesn't matter, we don't check server-side
        "MaxStorageGb" => nil,
        "Use2fa" => true,
        "UseDirectory" => false,
        "UseEvents" => false,
        "UseGroups" => false,
        "UseTotp" => true,
        "Object" => "organization"
      }

      Jason.encode!(encoded_struct)
    end
  end
end
