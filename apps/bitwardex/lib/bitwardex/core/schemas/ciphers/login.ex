defmodule Bitwardex.Core.Schemas.Ciphers.Login do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bitwardex.Core.Schemas.Ciphers.LoginUri

  @primary_key false

  embedded_schema do
    field :username, :string
    field :password, :string
    field :password_revision_date, :string
    field :totp, :string

    embeds_many :uris, LoginUri, on_replace: :delete
  end

  @required_fields []
  @optional_fields [
    :username,
    :password,
    :password_revision_date,
    :totp
  ]

  @doc false
  def changeset(folder, attrs) do
    folder
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> cast_embed(:uris)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, _opts) do
      encoded_struct = %{
        "Username" => struct.username,
        "Password" => struct.password,
        "PasswordRevisionDate" => struct.password_revision_date,
        "Totp" => struct.totp,
        "Uris" => struct.uris
      }

      Jason.encode!(encoded_struct)
    end
  end
end
