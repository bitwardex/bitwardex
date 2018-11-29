defmodule Bitwardex.Accounts.Schemas.UserCollection do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  alias Bitwardex.Accounts.Schemas.UserOrganization
  alias Bitwardex.Core.Schemas.Collection

  schema "users_collections" do
    field :read_only, :boolean, default: false

    belongs_to(:user_organization, UserOrganization)
    belongs_to(:collection, Collection)

    timestamps(type: :utc_datetime)
  end

  @required_fields [
    :read_only,
    :user_organization_id,
    :collection_id
  ]
  @optional_fields []

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:user_organization)
    |> assoc_constraint(:collection)
  end
end
