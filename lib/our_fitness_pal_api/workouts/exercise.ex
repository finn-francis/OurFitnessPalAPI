defmodule OurFitnessPalApi.Workouts.Exercise do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name, :description]}

  schema "exercises" do
    field :description, :string
    field :name, :string

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
