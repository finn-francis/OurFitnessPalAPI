defmodule OurFitnessPalApi.Repo.Migrations.AddForeignKeysToSetsTable do
  use Ecto.Migration

  def change do
    alter table(:sets) do
      add :session_id, references(:sessions)
    end
  end
end
