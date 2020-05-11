defmodule OurFitnessPalApiWeb.ExerciseController do
  use OurFitnessPalApiWeb, :controller

  alias OurFitnessPalApi.Workouts

  def index(conn, _params) do
    exercises = Workouts.list_exercises
    render conn, "index.json", exercises: exercises, message: ""
  end

  def show(conn, %{"id" => id}) do
    exercise = Workouts.get_exercise!(id)
    render(conn, "show.json", exercise: exercise)
  end

  def create(conn, %{"exercise" => exercise}) do
    case Workouts.create_exercise(exercise) do
      {:ok, _exercise} ->
        exercises = Workouts.list_exercises
        render conn, "index.json", %{exercises: exercises, message: "Exercise created"}
      {:error, changeset} ->
        render conn, "errors.json", changeset: changeset
    end
  end

  def update(conn, %{"id" => exercise_id, "exercise" => exercise}) do
    old_exercise = Workouts.get_exercise!(exercise_id)
    case Workouts.update_exercise(old_exercise, exercise) do
      {:ok, _exercise} ->
        exercises = Workouts.list_exercises
        render conn, "index.json", exercises: exercises, message: "Exercise updated"
      {:error, changeset} ->
        render conn, "errors.json", changeset: changeset
    end
  end

  def delete(conn, %{"id" => exercise_id}) do
    old_exercise = Workouts.get_exercise!(exercise_id)
    case Workouts.delete_exercise(old_exercise) do
      {:ok, _exercise} ->
        exercises = Workouts.list_exercises
        render conn, "index.json", exercises: exercises, message: "Exercise deleted"
      {:error, changeset} ->
        render conn, "errors.json", changeset: changeset
    end
  end
end