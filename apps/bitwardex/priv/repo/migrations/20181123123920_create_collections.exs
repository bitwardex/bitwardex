defmodule Bitwardex.Repo.Migrations.CreateCollections do
  use Ecto.Migration

  def change do
    create table(:collections, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :text, null: false

      add :organization_id, references(:organizations, on_delete: :delete_all, type: :binary_id),
        null: false

      timestamps()
    end

    create index(:collections, [:organization_id])
  end
end
