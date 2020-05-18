defmodule OurFitnessPalApi.Sessions.Set do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sets" do
    field :name, :string

    belongs_to :session, OurFitnessPalApi.Sessions.Session
    has_many :set_exercises, OurFitnessPalApi.Sessions.SetExercise, on_replace: :delete, on_delete: :delete_all
    many_to_many :exercises, OurFitnessPalApi.Workouts.Exercise, join_through: OurFitnessPalApi.Sessions.SetExercise

    timestamps()
  end

  @doc false
  def changeset(set, attrs) do
    set
    |> cast(attrs, [:name, :session_id])
    |> cast_assoc(:set_exercises, required: true)
    |> validate_required([:name])
  end
end
