defmodule Bitwardex.Repo.Migrations.AddOrganizationIdToCiphers do
  use Ecto.Migration

  def change do
    alter table(:ciphers) do
      add :organization_id, references(:organizations, on_delete: :delete_all, type: :binary_id)
    end

    create index(:ciphers, [:organization_id])
  end
end
