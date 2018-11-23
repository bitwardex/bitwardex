defmodule Bitwardex.Repo.Migrations.AddKeysToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :keys, :map, default: "{}"
    end
  end
end
