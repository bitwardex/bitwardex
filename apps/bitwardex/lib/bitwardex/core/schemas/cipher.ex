defmodule Bitwardex.Core.Schemas.Cipher do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bitwardex.Accounts.Schemas.Organization
  alias Bitwardex.Accounts.Schemas.User
  alias Bitwardex.Core.Schemas.CipherCollection
  alias Bitwardex.Core.Schemas.CipherFolder
  alias Bitwardex.Core.Schemas.Collection
  alias Bitwardex.Core.Schemas.Field

  alias Bitwardex.Core.Schemas.Ciphers.Card
  alias Bitwardex.Core.Schemas.Ciphers.Identity
  alias Bitwardex.Core.Schemas.Ciphers.Login
  alias Bitwardex.Core.Schemas.Ciphers.SecureNote

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "ciphers" do
    field :name, :string
    field :notes, :string
    field :favorite, :boolean
    field :type, :integer

    belongs_to :user, User
    belongs_to :organization, Organization

    has_many :cipher_folders, CipherFolder
    has_many :folder, through: [:cipher_folders, :folder]

    many_to_many :collections, Collection,
      join_through: CipherCollection,
      on_replace: :delete

    embeds_many :fields, Field, on_replace: :delete
    embeds_one :card, Card, on_replace: :delete
    embeds_one :identity, Identity, on_replace: :delete
    embeds_one :login, Login, on_replace: :delete
    embeds_one :secure_note, SecureNote, on_replace: :delete

    timestamps()
  end

  @required_fields [:name]
  @optional_fields_create [:notes, :favorite, :type, :user_id, :organization_id]
  @optional_fields_update [:notes, :favorite, :type]

  @doc false
  def changeset_create(cipher, attrs) do
    cipher
    |> cast(attrs, @required_fields ++ @optional_fields_create)
    |> validate_required(@required_fields)
    |> validate_ownership()
    |> assoc_constraint(:user)
    |> assoc_constraint(:organization)
    |> cast_embed(:fields)
    |> cast_embed(:card)
    |> cast_embed(:identity)
    |> cast_embed(:login)
    |> cast_embed(:secure_note)
  end

  @doc false
  def changeset_update(cipher, attrs) do
    cipher
    |> cast(attrs, @required_fields ++ @optional_fields_update)
    |> validate_required(@required_fields)
    |> validate_ownership()
    |> assoc_constraint(:user)
    |> assoc_constraint(:organization)
    |> cast_embed(:fields)
    |> cast_embed(:card)
    |> cast_embed(:identity)
    |> cast_embed(:login)
    |> cast_embed(:secure_note)
  end

  defp validate_ownership(changeset) do
    case changeset.valid? do
      true ->
        user_id = get_field(changeset, :user_id)
        org_id = get_field(changeset, :organization_id)

        case {user_id, org_id} do
          {nil, _org_id} ->
            changeset

          {_user_id, nil} ->
            changeset

          _ ->
            add_error(
              changeset,
              :user_id,
              "Either user_id or organization_id must be present, not both or none of them."
            )
        end

      _ ->
        changeset
    end
  end
end
