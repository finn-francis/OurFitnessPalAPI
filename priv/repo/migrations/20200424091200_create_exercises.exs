defmodule OurFitnessPalApi.Repo.Migrations.CreateExercises do
  use Ecto.Migration

  def change do
    create table(:exercises) do
      add :name, :string
      add :description, :text

      timestamps()
    end

    create unique_index(:exercises, [:name])
  end
end
