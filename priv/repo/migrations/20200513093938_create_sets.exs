defmodule OurFitnessPalApi.Repo.Migrations.CreateSets do
  use Ecto.Migration

  def change do
    create table(:sets) do
      add :name, :string

      timestamps()
    end

  end
end
