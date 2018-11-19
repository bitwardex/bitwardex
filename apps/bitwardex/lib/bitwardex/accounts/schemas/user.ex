defmodule Bitwardex.Accounts.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :culture, :string, default: "en-US"
    field :email, :string
    field :email_verified, :boolean, default: false
    field :kdf, :integer
    field :kdf_iterations, :integer
    field :key, :string
    field :master_password_hash, :string
    field :master_password_hint, :string
    field :name, :string
    field :premium, :boolean, default: true

    timestamps()
  end

  @required_fields [:email, :master_password_hash, :key, :kdf, :kdf_iterations]
  @optional_fields [:name, :master_password_hint, :email_verified, :premium, :culture]

  @email_regex ~r/^[A-Za-z0-9._%+-\\']+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, @email_regex)
    |> unique_constraint(:email)
  end
end
