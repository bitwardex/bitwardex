defmodule Bitwardex.Core.Schemas.Collection do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bitwardex.Accounts.Schemas.Organization
  alias Bitwardex.Accounts.Schemas.UserCollection
  alias Bitwardex.Core.Schemas.Cipher
  alias Bitwardex.Core.Schemas.CipherCollection

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "collections" do
    field :name, :string

    belongs_to :organization, Organization

    has_many :collection_users, UserCollection
    has_many :users, through: [:collection_users, :users]

    many_to_many :ciphers, Cipher,
      join_through: CipherCollection,
      on_replace: :delete

    timestamps()
  end

  @required_field [
    :name,
    :organization_id
  ]

  @optional_fields []

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, @required_field ++ @optional_fields)
    |> validate_required(@required_field)
    |> assoc_constraint(:organization)
  end
end
