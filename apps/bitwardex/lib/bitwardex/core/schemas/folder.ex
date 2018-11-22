defmodule Bitwardex.Core.Schemas.Folder do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bitwardex.Accounts.Schemas.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "folders" do
    field :name, :string

    belongs_to :user, User

    timestamps()
  end

  @required_field [
    :name,
    :user_id
  ]

  @optional_fields []

  @doc false
  def changeset(folder, attrs) do
    folder
    |> cast(attrs, @required_field ++ @optional_fields)
    |> validate_required(@required_field)
    |> assoc_constraint(:user)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, _opts) do
      encoded_struct = %{
        "Id" => struct.id,
        "Name" => struct.name,
        "RevisionDate" => NaiveDateTime.to_iso8601(struct.updated_at),
        "Object" => "folder"
      }

      Jason.encode!(encoded_struct)
    end
  end
end
