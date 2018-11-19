defmodule Bitwardex.Core.Schemas.Cipher do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bitwardex.Accounts.Schemas.User
  alias Bitwardex.Core.Schemas.Field
  alias Bitwardex.Core.Schemas.Folder

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "ciphers" do
    field :name, :string
    field :notes, :string
    field :favorite, :boolean
    field :type, :integer

    field :login, :map
    belongs_to :user, User
    belongs_to :folder, Folder

    embeds_many :fields, Field, on_replace: :delete

    timestamps()
  end

  @required_field [:name, :user_id]
  @optional_fields [:notes, :favorite, :type, :login, :folder_id]

  @doc false
  def changeset(folder, attrs) do
    folder
    |> cast(attrs, @required_field ++ @optional_fields)
    |> validate_required(@required_field)
    |> assoc_constraint(:user)
    |> assoc_constraint(:folder)
    |> cast_embed(:fields)
  end
end
