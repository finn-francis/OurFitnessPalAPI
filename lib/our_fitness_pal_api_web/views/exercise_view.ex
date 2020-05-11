defmodule OurFitnessPalApiWeb.ExerciseView do
  use OurFitnessPalApiWeb, :view

  def render("index.json", %{exercises: exercises, message: message}) do
    %{
      exercises: Enum.map(exercises, &exercise_json/1),
      message: message
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
      id: exercise.id,
      name: exercise.name,
      description: exercise.description
    }
  end

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end
end
