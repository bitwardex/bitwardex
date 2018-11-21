defmodule Bitwardex.Core.Schemas.Cipher do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bitwardex.Accounts.Schemas.User
  alias Bitwardex.Core.Schemas.Field
  alias Bitwardex.Core.Schemas.Folder

  alias Bitwardex.Core.Schemas.Ciphers.Identity
  alias Bitwardex.Core.Schemas.Ciphers.SecureNote

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "ciphers" do
    field :name, :string
    field :notes, :string
    field :favorite, :boolean
    field :type, :integer

    field :login, :map
    field :card, :map

    belongs_to :user, User
    belongs_to :folder, Folder

    embeds_many :fields, Field, on_replace: :delete
    embeds_one :secure_note, SecureNote
    embeds_one :identity, Identity

    timestamps()
  end

  @required_field [:name, :user_id]
  @optional_fields [:notes, :favorite, :type, :login, :card, :identity, :folder_id]

  @doc false
  def changeset(folder, attrs) do
    folder
    |> cast(attrs, @required_field ++ @optional_fields)
    |> validate_required(@required_field)
    |> assoc_constraint(:user)
    |> assoc_constraint(:folder)
    |> cast_embed(:fields)
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
        "OrganizationId" => nil,
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
