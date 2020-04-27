defmodule OurFitnessPalApiWeb.ExerciseControllerTest do
  use OurFitnessPalApiWeb.ConnCase
  require OurFitnessPalApi.Factory

  alias OurFitnessPalApi.Factory
  alias OurFitnessPalApi.Workouts

  @create_attrs %{name: "Bench Press", description: "Lift the weight"}
  @invalid_attrs %{name: "", description: ""}

  test "#index renders a list of exercises" do
    conn = build_conn()
    exercise = Factory.insert(:exercise)

    conn = get conn, Routes.exercise_path(conn, :index)

    assert json_response(conn, 200) == %{
      "exercises" => [%{
        "name" => exercise.name,
        "description" => exercise.description,
      }]
    }
  end

  test "#show renders a single exercise" do
    conn = build_conn()
    exercise = Factory.insert(:exercise)

    conn = get conn, Routes.exercise_path(conn, :show, exercise)

    assert json_response(conn, 200) == %{
      "exercise" => %{
        "name" => exercise.name,
        "description" => exercise.description
      }
    }
  end

  test "#create adds an exercise record and renders a list of exercises when called with valid attributes" do
    conn = build_conn()

    conn = post conn, Routes.exercise_path(conn, :create, exercise: @create_attrs)

    exercise = Workouts.list_exercises
      |> List.first

    assert json_response(conn, 200) == %{
      "exercises" => [%{
        "name" => exercise.name,
        "description" => exercise.description,
      }]
    }
  end

  test "#create returns a list of errors when called with invalid attributes" do
    conn = build_conn()

    conn = post conn, Routes.exercise_path(conn, :create, exercise: @invalid_attrs)

    exercises = Workouts.list_exercises
    assert exercises == []

    assert json_response(conn, 200) == %{
      "errors" => %{
        "name" => ["can't be blank"],
        "description" => ["can't be blank"],
      }
    }
  end
end