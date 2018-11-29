defmodule Bitwardex.Core.Schemas.Folder do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bitwardex.Accounts.Schemas.User
  alias Bitwardex.Core.Schemas.CipherFolder

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "folders" do
    field :name, :string

    belongs_to :user, User

    has_many :folder_ciphers, CipherFolder
    has_many :ciphers, through: [:folder_ciphers, :cipher]

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
end
