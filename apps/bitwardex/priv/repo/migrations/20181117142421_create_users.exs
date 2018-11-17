defmodule Bitwardex.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :email, :string, null: false
      add :master_password_hash, :string, null: false
      add :master_password_hint, :string
      add :key, :string, null: false
      add :kdf, :integer, null: false
      add :kdf_iterations, :integer, null: false
      add :email_verified, :boolean, default: false, null: false
      add :premium, :boolean, default: true, null: false
      add :culture, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
