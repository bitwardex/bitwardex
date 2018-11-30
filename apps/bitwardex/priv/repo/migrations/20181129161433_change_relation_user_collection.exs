defmodule Bitwardex.Repo.Migrations.ChangeRelationUserCollection do
  use Ecto.Migration

  def change do
    drop index(:users_collections, [:user_id])

    alter table(:users_collections) do
      remove :user_id

      add :user_organization_id,
          references(:users_organizations, on_delete: :delete_all, type: :binary_id),
          null: false
    end

    create index(:users_collections, [:user_organization_id])
  end
end
