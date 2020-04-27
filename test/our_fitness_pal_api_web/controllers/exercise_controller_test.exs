defmodule OurFitnessPalApiWeb.ExerciseControllerTest do
  use OurFitnessPalApiWeb.ConnCase
  require OurFitnessPalApi.Factory

  alias OurFitnessPalApi.Factory


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
end