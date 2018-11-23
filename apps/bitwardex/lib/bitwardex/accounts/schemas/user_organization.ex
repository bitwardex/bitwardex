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
    :organization_id
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
end
