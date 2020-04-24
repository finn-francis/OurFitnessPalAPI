defmodule OurFitnessPalApiWeb.ExerciseController do
  use OurFitnessPalApiWeb, :controller

  alias OurFitnessPalApi.Workouts

  def index(conn, _params) do
    exercises = Workouts.list_exercises
    json(conn, %{"exercises" => exercises})
  end
end