defmodule OurFitnessPalApiWeb.ExerciseViewTest do
  require OurFitnessPalApi.Factory
  use OurFitnessPalApiWeb.ConnCase, async: true

  alias OurFitnessPalApiWeb.ExerciseView
  alias OurFitnessPalApi.Factory

  test "exercise_json" do
    exercise = Factory.insert(:exercise)

    rendered_exercise = ExerciseView.exercise_json(exercise)

    assert rendered_exercise == %{
      name: exercise.name,
      description: exercise.description
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
end