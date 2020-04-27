defmodule OurFitnessPalApiWeb.ExerciseController do
  use OurFitnessPalApiWeb, :controller

  alias OurFitnessPalApi.Workouts

  def index(conn, _params) do
    exercises = Workouts.list_exercises
    render conn, "index.json", exercises: exercises
  end

  def show(conn, %{"id" => id}) do
    exercise = Workouts.get_exercise!(id)
    render(conn, "show.json", exercise: exercise)
  end
end