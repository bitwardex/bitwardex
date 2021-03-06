defmodule Bitwardex.Accounts.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bitwardex.Accounts.Schemas.Keys
  alias Bitwardex.Accounts.Schemas.UserOrganization
  alias Bitwardex.Core.Schemas.Cipher
  alias Bitwardex.Core.Schemas.Folder

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "users" do
    field :culture, :string, default: "en-US"
    field :email, :string
    field :email_verified, :boolean, default: true
    field :kdf, :integer
    field :kdf_iterations, :integer
    field :key, :string
    field :master_password_hash, :string
    field :master_password_hint, :string
    field :name, :string
    field :premium, :boolean, default: true

    embeds_one :keys, Keys
    has_many :ciphers, Cipher
    has_many :folders, Folder

    has_many :user_organizations, UserOrganization
    has_many :confirmed_user_organizations, UserOrganization, where: [status: 2]
    has_many :organizations, through: [:confirmed_user_organizations, :organization]
    has_many :user_collections, through: [:confirmed_user_organizations, :user_collections]

    timestamps(type: :utc_datetime)
  end

  @required_fields [:email, :master_password_hash, :key, :kdf, :kdf_iterations]
  @optional_fields [:name, :master_password_hint, :email_verified, :premium, :culture]

  @email_regex ~r/^[A-Za-z0-9._%+-\\']+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_embed(:keys, required: true)
    |> validate_required(@required_fields)
    |> validate_format(:email, @email_regex)
    |> validate_email_domain()
    |> unique_constraint(:email)
  end

  defp validate_email_domain(changeset) do
    case changeset.valid? do
      true ->
        email = get_field(changeset, :email)

        required_domain =
          :bitwardex
          |> Application.get_env(Bitwardex.Accounts, Keyword.new())
          |> Keyword.get(:required_domain, "")

        case {email, required_domain} do
          {_email, required_domain} when required_domain in [nil, ""] ->
            changeset

          {email, required_domain} ->
            if String.ends_with?(email, "@#{required_domain}") do
              changeset
            else
              add_error(changeset, :email, "Email domain not whitelisted")
            end
        end

      _ ->
        changeset
    end
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, _opts) do
      encoded_struct = %{
        "Id" => struct.id,
        "Name" => struct.name,
        "Email" => struct.email,
        "EmailVerified" => struct.email_verified,
        "Premium" => struct.premium,
        "MasterPasswordHint" => struct.master_password_hint,
        "Culture" => struct.culture,
        "TwoFactorEnabled" => false,
        "Key" => struct.key,
        "PrivateKey" => struct.keys.encrypted_private_key,
        "SecurityStamp" => struct.id,
        "Organizations" => struct.confirmed_user_organizations,
        "Object" => "profile"
      }

      Jason.encode!(encoded_struct)
    end
  end
end
