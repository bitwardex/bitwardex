defmodule Bitwardex.Repo.Migrations.CreateUsersCollections do
  use Ecto.Migration

  def change do
    create table(:users_collections, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :read_only, :boolean, default: false, null: false

      add :collection_id, references(:collections, on_delete: :delete_all, type: :binary_id),
        null: false

      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:users_collections, [:collection_id])
    create index(:users_collections, [:user_id])
  end
end
