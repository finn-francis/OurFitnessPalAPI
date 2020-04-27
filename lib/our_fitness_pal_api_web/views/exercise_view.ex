defmodule OurFitnessPalApiWeb.ExerciseView do
  use OurFitnessPalApiWeb, :view

  def render("index.json", %{exercises: exercises}) do
    %{
      exercises: Enum.map(exercises, &exercise_json/1)
    }
  end

  def render("show.json", %{exercise: exercise}) do
    %{exercise: exercise_json(exercise)}
  end

  def render("errors.json", %{changeset: changeset}) do
    %{errors: translate_errors(changeset)}
  end

  def exercise_json(exercise) do
    %{
      name: exercise.name,
      description: exercise.description
    }
  end

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end
end
