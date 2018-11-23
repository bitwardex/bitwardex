defmodule Bitwardex.Repo.Migrations.CreateCiphersCollections do
  use Ecto.Migration

  def change do
    create table(:ciphers_collections, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :organization_id, references(:organizations, on_delete: :delete_all, type: :binary_id),
        null: false

      add :cipher_id, references(:ciphers, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:ciphers_collections, [:organization_id])
    create index(:ciphers_collections, [:cipher_id])
  end
end
