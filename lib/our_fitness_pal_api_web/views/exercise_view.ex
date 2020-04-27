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

  def exercise_json(exercise) do
    %{
      name: exercise.name,
      description: exercise.description
    }
  end
end
