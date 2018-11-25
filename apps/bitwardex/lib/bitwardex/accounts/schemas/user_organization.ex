defmodule Bitwardex.Accounts.Schemas.UserOrganization do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  alias Bitwardex.Accounts.Schemas.User
  alias Bitwardex.Accounts.Schemas.Organization

  schema "users_organizations" do
    field :access_all, :boolean
    field :key, :string

    field :status, :integer
    field :type, :integer

    belongs_to(:user, User)
    belongs_to(:organization, Organization)

    timestamps(type: :utc_datetime)
  end

  @required_fields [
    :access_all,
    :key,
    :user_id,
    :organization_id,
    :status,
    :type
  ]
  @optional_fields []

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:user)
    |> assoc_constraint(:organization)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, _opts) do
      encoded_struct = %{
        "Id" => struct.organization.id,
        "Name" => struct.organization.name,
        "Key" => struct.key,
        "Status" => struct.status,
        "Type" => struct.type,
        "Enabled" => true,

        # Organization-hardcoded values
        # TODO: Move this to the organization schema to persist it in DB
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
        "Object" => "profileOrganization"
      }

      Jason.encode!(encoded_struct)
    end
  end
end
