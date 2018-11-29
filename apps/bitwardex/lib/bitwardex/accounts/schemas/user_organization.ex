defmodule Bitwardex.Accounts.Schemas.UserOrganization do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  alias Bitwardex.Accounts.Schemas.Organization
  alias Bitwardex.Accounts.Schemas.User
  alias Bitwardex.Accounts.Schemas.UserCollection

  schema "users_organizations" do
    field :access_all, :boolean
    field :key, :string

    field :status, :integer
    field :type, :integer

    field :invite_token, Ecto.UUID, default: Ecto.UUID.generate()

    belongs_to(:user, User)
    belongs_to(:organization, Organization)

    has_many :user_collections, UserCollection
    has_many :collections, through: [:user_collections, :collection]

    timestamps(type: :utc_datetime)
  end

  # @user_types %{
  #   owner: 0,
  #   admin: 1,
  #   user: 2,
  #   manager: 3
  # }

  # @user_status %{
  #   invited: 0,
  #   accepted: 1,
  #   confirmed: 2
  # }

  @required_fields [
    :access_all,
    :user_id,
    :organization_id,
    :status,
    :type
  ]
  @optional_fields [
    :invite_token,
    :key
  ]

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_keys()
    |> assoc_constraint(:user)
    |> assoc_constraint(:organization)
  end

  defp validate_keys(changeset) do
    case changeset.valid? do
      true ->
        status = get_field(changeset, :status)
        invite_token = get_field(changeset, :invite_token)
        key = get_field(changeset, :key)

        case {status, invite_token, key} do
          {2, _invite_token, _key} when not is_bitstring(key) or key == "" ->
            add_error(changeset, :key, "Key is needed when user us confirmed.")

          {status, invite_token, _key}
          when status in [0, 1] and (not is_bitstring(invite_token) or invite_token == "") ->
            add_error(changeset, :invite_token, "Invite token is needed for users not confirmed.")

          _ ->
            changeset
        end

      _ ->
        changeset
    end
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
