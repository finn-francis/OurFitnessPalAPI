defmodule OurFitnessPalApiWeb.ExerciseControllerTest do
  use OurFitnessPalApiWeb.ConnCase
  require OurFitnessPalApi.Factory

  alias OurFitnessPalApi.Factory
  alias OurFitnessPalApi.Workouts

  @valid_attrs %{name: "Bench Press", description: "Lift the weight"}
  @invalid_attrs %{name: "", description: ""}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "#index renders a list of exercises", %{conn: conn} do
    exercise = Factory.insert(:exercise)

    conn = get conn, Routes.exercise_path(conn, :index)

    assert json_response(conn, 200) == %{
      "exercises" => [%{
        "name" => exercise.name,
        "description" => exercise.description,
        "id" => exercise.id
      }],
      "message" => ""
    }
  end

  test "#show renders a single exercise", %{conn: conn} do
    exercise = Factory.insert(:exercise)

    conn = get conn, Routes.exercise_path(conn, :show, exercise)

    assert json_response(conn, 200) == %{
      "exercise" => %{
        "name" => exercise.name,
        "description" => exercise.description,
        "id" => exercise.id
      },
      "message" => ""
    }
  end

  @tag :authenticated
  test "#create adds an exercise record and renders a list of exercises when called with valid attributes", %{conn: conn} do
    conn = post conn, Routes.exercise_path(conn, :create, exercise: @valid_attrs)

    exercise = Workouts.list_exercises
      |> List.first

    assert json_response(conn, 200) == %{
      "exercise" => %{
        "name" => exercise.name,
        "description" => exercise.description,
        "id" => exercise.id
      },
      "message" => "Exercise created"
    }
  end

  @tag :authenticated
  test "#create returns a list of errors when called with invalid attributes", %{conn: conn} do

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

  @tag :authenticated
  test "update changes an exercise record and renders a list of exercises when called with valid attributes", %{conn: conn} do
    exercise = Factory.insert(:exercise)

    conn = put conn, Routes.exercise_path(conn, :update, exercise, exercise: @valid_attrs)

    updated_exercise = Workouts.get_exercise!(exercise.id)

    assert updated_exercise.name == @valid_attrs.name
    assert updated_exercise.description == @valid_attrs.description

    assert json_response(conn, 200) == %{
      "exercise" => %{
        "name" => updated_exercise.name,
        "description" => updated_exercise.description,
        "id" => exercise.id
      },
      "message" => "Exercise updated"
    }
  end

  @tag :authenticated
  test "#update returns a list of errors when called with invalid attributes", %{conn: conn} do
    exercise = Factory.insert(:exercise)

    conn = put conn, Routes.exercise_path(conn, :update, exercise, exercise: @invalid_attrs)

    updated_exercise = Workouts.get_exercise!(exercise.id)

    assert updated_exercise.name == exercise.name
    assert updated_exercise.description == exercise.description

    assert json_response(conn, 200) == %{
      "errors" => %{
        "name" => ["can't be blank"],
        "description" => ["can't be blank"],
      }
    }
  end

  @tag :authenticated
  test "#delete removes an exercise record and returns a list of exercises", %{conn: conn} do
    exercise = Factory.insert(:exercise)
    conn = delete conn, Routes.exercise_path(conn, :delete, exercise)

    assert json_response(conn, 200) == %{
      "exercise" => %{
        "name" => exercise.name,
        "description" => exercise.description,
        "id" => exercise.id
      },
      "message" => "Exercise deleted"
    }
  end
end
