defmodule OurFitnessPalApi.Repo.Migrations.AddForeignKeysToSetExercisesTable do
  use Ecto.Migration

  def change do
    alter table(:set_exercises) do
      add :exercise_id, references(:exercises)
      add :set_id, references(:sets)
    end
  end
end
