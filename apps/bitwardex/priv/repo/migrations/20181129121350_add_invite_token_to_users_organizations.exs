defmodule Bitwardex.Repo.Migrations.AddInviteTokenToUsersOrganizations do
  use Ecto.Migration

  def change do
    alter table(:users_organizations) do
      add :invite_token, :uuid
      modify :key, :text, null: true
    end
  end
end
