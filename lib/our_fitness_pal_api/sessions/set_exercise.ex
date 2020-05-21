defmodule OurFitnessPalApi.Sessions.SetExercise do
  use Ecto.Schema
  import Ecto.Changeset

  schema "set_exercises" do
    field :unit, :string

    belongs_to :exercise, OurFitnessPalApi.Workouts.Exercise
    belongs_to :set, OurFitnessPalApi.Sessions.Set

    timestamps()
  end

  @doc false
  def changeset(set_exercise, attrs) do
    set_exercise
    |> cast(attrs, [:unit])
    |> validate_required([:unit])
    |> validate_inclusion(:unit, ["Reps", "Distance", "Time"])
  end
end
