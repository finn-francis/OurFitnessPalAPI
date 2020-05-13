defmodule OurFitnessPalApi.Sessions.Set do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sets" do
    field :name, :string

    belongs_to :session, OurFitnessPalApi.Sessions.Session
    many_to_many :exercises, Workout.Exercise, join_through: SetExercise

    timestamps()
  end

  @doc false
  def changeset(set, attrs) do
    set
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
