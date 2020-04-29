defmodule OurFitnessPalApiWeb.ExerciseViewTest do
  require OurFitnessPalApi.Factory
  use OurFitnessPalApiWeb.ConnCase, async: true

  alias OurFitnessPalApiWeb.ExerciseView
  alias OurFitnessPalApi.Factory
  alias OurFitnessPalApi.Workouts

  test "exercise_json" do
    exercise = Factory.insert(:exercise)

    rendered_exercise = ExerciseView.exercise_json(exercise)

    assert rendered_exercise == %{
      name: exercise.name,
      description: exercise.description,
      id: exercise.id
    }
  end

  test "index.json" do
    exercise = Factory.insert(:exercise)

    rendered_exercises = ExerciseView.render("index.json", %{exercises: [exercise]})

    assert rendered_exercises == %{
      exercises: [ExerciseView.exercise_json(exercise)]
    }
  end

  test "show.json" do
    exercise = Factory.insert(:exercise)

    rendered_exercise = ExerciseView.render("show.json", %{exercise: exercise})

    assert rendered_exercise == %{
      exercise: ExerciseView.exercise_json(exercise)
    }
  end

  test "errors.json" do
    exercise = %{name: "", description: ""}
    {_error, changeset} = Workouts.create_exercise(exercise)

    rendered_errors = ExerciseView.render("errors.json", %{changeset: changeset})
    assert rendered_errors == %{
      errors: ExerciseView.translate_errors(changeset)
    }
  end
end
