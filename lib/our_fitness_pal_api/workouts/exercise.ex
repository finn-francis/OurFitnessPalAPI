defmodule OurFitnessPalApi.Workouts.Exercise do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :description]}

  schema "exercises" do
    field :description, :string
    field :name, :string

    many_to_many :sets, Sessions.Session, join_through: SetExercise

    timestamps()
  end

  @doc false
  def changeset(exercise, attrs) do
    exercise
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
    |> unique_constraint(:name)
  end
end
