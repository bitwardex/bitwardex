defmodule Bitwardex.Core.Schemas.Cipher do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bitwardex.Accounts.Schemas.Organization
  alias Bitwardex.Accounts.Schemas.User
  alias Bitwardex.Core.Schemas.CipherCollection
  alias Bitwardex.Core.Schemas.Collection
  alias Bitwardex.Core.Schemas.Field
  alias Bitwardex.Core.Schemas.Folder

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
    belongs_to :folder, Folder

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

  @required_field [:name]
  @optional_fields [:notes, :favorite, :type, :folder_id, :user_id, :organization_id]

  @doc false
  def changeset(folder, attrs) do
    folder
    |> cast(attrs, @required_field ++ @optional_fields)
    |> validate_required(@required_field)
    |> assoc_constraint(:user)
    |> assoc_constraint(:organization)
    |> assoc_constraint(:folder)
    |> cast_embed(:fields)
    |> cast_embed(:card)
    |> cast_embed(:identity)
    |> cast_embed(:login)
    |> cast_embed(:secure_note)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(%{type: 1} = struct, _opts) do
      encoded_struct =
        struct
        |> get_base_struct()
        |> Map.put("Login", struct.login)

      Jason.encode!(encoded_struct)
    end

    def encode(%{type: 2} = struct, _opts) do
      encoded_struct =
        struct
        |> get_base_struct()
        |> Map.put("SecureNote", struct.secure_note)

      Jason.encode!(encoded_struct)
    end

    def encode(%{type: 3} = struct, _opts) do
      encoded_struct =
        struct
        |> get_base_struct()
        |> Map.put("Card", struct.card)

      Jason.encode!(encoded_struct)
    end

    def encode(%{type: 4} = struct, _opts) do
      encoded_struct =
        struct
        |> get_base_struct()
        |> Map.put("Identity", struct.identity)

      Jason.encode!(encoded_struct)
    end

    defp get_base_struct(struct) do
      %{
        "Name" => struct.name,
        "FolderId" => struct.folder_id,
        "Favorite" => struct.favorite,
        "Edit" => true,
        "Id" => struct.id,
        "OrganizationId" => struct.organization_id,
        "CollectionIds" => Enum.map(struct.collections, & &1.id),
        "Type" => struct.type,
        "Notes" => struct.notes,
        "Fields" => struct.fields,
        "Attachments" => [],
        "OrganizationUseTotp" => false,
        "RevisionDate" => NaiveDateTime.to_iso8601(struct.updated_at),
        "Object" => "cipher"
      }
    end
  end
end
