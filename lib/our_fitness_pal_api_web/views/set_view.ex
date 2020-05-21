defmodule OurFitnessPalApiWeb.SetView do
  use OurFitnessPalApiWeb, :view

  def render("index.json", %{sets: sets, message: message}) do
    %{
      sets: Enum.map(sets, &set_json/1),
      message: message
    }
  end

  def render("show.json", %{set: set} = params) do
    message = params[:message] || ""
    %{set: set_json(set), message: message}
  end

  def render("errors.json", %{changeset: changeset}) do
    %{errors: translate_errors(changeset)}
  end

  def set_json(set) do
    %{
      id: set.id,
      name: set.name,
      set_exercises: Enum.map(set.set_exercises, &set_exercise_json/1)
    }
  end

  def set_exercise_json(set_exercise) do
    %{
      id: set_exercise.id,
      exercise_name: set_exercise.exercise.name,
      exercise_description: set_exercise.exercise.description,
      unit: set_exercise.unit
    }
  end

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end
end
