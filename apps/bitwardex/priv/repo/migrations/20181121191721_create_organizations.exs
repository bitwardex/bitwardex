defmodule Bitwardex.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :string, null: false
      add :billing_email, :string, null: false

      add :business_name, :string
      add :business_address1, :string
      add :business_address2, :string
      add :business_address3, :string
      add :business_country, :string
      add :business_tax_number, :string

      timestamps()
    end
  end
end
