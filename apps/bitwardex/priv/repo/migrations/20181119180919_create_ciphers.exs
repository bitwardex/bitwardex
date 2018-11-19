defmodule Bitwardex.Repo.Migrations.CreateCiphers do
  use Ecto.Migration

  def change do
    create table(:ciphers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :notes, :text
      add :favorite, :boolean

      add :login, :map, default: "{}"
      add :type, :integer, null: false

      add :fields, :map, default: "[]"

      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :folder_id, references(:folders, on_delete: :nilify_all, type: :binary_id)

      timestamps()
    end

    create index(:ciphers, [:user_id])
    create index(:ciphers, [:folder_id])
  end
end
