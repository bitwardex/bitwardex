defmodule Bitwardex.Repo.Migrations.CreateUsersCiphersFolders do
  use Ecto.Migration

  def up do
    create table(:ciphers_folders, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false
      add :folder_id, references(:folders, on_delete: :delete_all, type: :binary_id), null: false
      add :cipher_id, references(:ciphers, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:ciphers_folders, [:user_id])
    create index(:ciphers_folders, [:folder_id])
    create index(:ciphers_folders, [:cipher_id])
    create unique_index(:ciphers_folders, [:cipher_id, :user_id])

    drop index(:ciphers, [:folder_id])

    alter table(:ciphers) do
      remove :folder_id
    end
  end

  def down do
    drop table(:ciphers_folders)

    alter table(:ciphers) do
      add :folder_id, references(:folders, on_delete: :nilify_all, type: :binary_id)
    end

    create index(:ciphers, [:folder_id])
  end
end
