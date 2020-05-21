defmodule OurFitnessPalApi.Repo.Migrations.CreateSetExercises do
  use Ecto.Migration

  def change do
    create table(:set_exercises) do
      add :unit, :string

      timestamps()
    end

  end
end
