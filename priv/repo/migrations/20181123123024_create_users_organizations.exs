defmodule Bitwardex.Repo.Migrations.CreateUsersOrganizations do
  use Ecto.Migration

  def change do
    create table(:users_organizations, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :access_all, :boolean, default: false, null: false
      add :key, :text, null: false
      add :status, :integer, null: false
      add :type, :integer, null: false

      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false

      add :organization_id, references(:organizations, on_delete: :delete_all, type: :binary_id),
        null: false

      timestamps()
    end

    create index(:users_organizations, [:user_id])
    create index(:users_organizations, [:organization_id])
  end
end
