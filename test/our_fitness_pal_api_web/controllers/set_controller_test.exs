defmodule OurFitnessPalApiWeb.SetControllerTest do
  use OurFitnessPalApiWeb.ConnCase
  require OurFitnessPalApi.Factory

  alias OurFitnessPalApi.Factory

  alias OurFitnessPalApi.Sessions

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag :authenticated
    test "#index renders a list of sets", %{conn: conn} do
      session = Factory.insert(:session, %{name: "Leg Day", description: "Do Legs"})
      exercise = Factory.insert(:exercise, %{name: "Squat", description: "Go Low"})
      set1 = Factory.insert(:set, %{session: session, name: "first", exercises: [exercise]})
      set2 = Factory.insert(:set, %{session: session, name: "second", exercises: [exercise]})

      conn = get conn, Routes.session_set_path(conn, :index, session.id)

      set1_id = set1.id
      set2_id = set2.id

      assert %{
        "sets" => [
          %{"id" => ^set1_id, "name" => "first"  ,
            "set_exercises" => [%{"id" => id1, "exercise_name" => "Squat", "exercise_description" => "Go Low", "unit" => unit}]
          },
          %{
            "id" => ^set2_id, "name" => "second",
            "set_exercises" => [%{"id" => id2, "exercise_name" => "Squat", "exercise_description" => "Go Low", "unit" => unit}]
          }
        ],
        "message" => ""
      } = json_response(conn, 200)
    end
  end

  describe "create set" do
    @tag :authenticated
    test "renders set when data is valid", %{conn: conn} do
      exercise = Factory.insert(:exercise)
      session = Factory.insert(:session)
      conn = post conn, Routes.session_set_path(conn, :create, session.id), set: %{
        name: "some name",
        set_exercises: %{
          "0" => %{
            unit: "Distance",
            exercise_id: exercise.id
          }
        }
      }

      set = Sessions.list_sets(session.id)
        |> List.first

      set_id = set.id
      set_name = set.name
      exercise_name = exercise.name
      exercise_description = exercise.description

      assert %{
        "set" => %{
          "id" => ^set_id, "name" => ^set_name,
          "set_exercises" => [%{"id" => id, "exercise_name" => ^exercise_name, "exercise_description" => ^exercise_description, "unit" => "Distance"}]
        },
        "message" => "Set created"
      } = json_response(conn, 200)

    end

  @tag :authenticated
  test "#create returns a list of errors when called with invalid attributes", %{conn: conn} do
    session = Factory.insert(:session)
    conn = post conn, Routes.session_set_path(conn, :create, session.id), set: %{
      name: "",
      set_exercises: %{
        "0" => %{
          unit: "",
          exercise_id: ""
        }
      }
    }

    sets = Sessions.list_sets
    assert sets == []

    assert json_response(conn, 200) == %{
      "errors" => %{
        "name" => ["can't be blank"],
        "set_exercises" => [%{"unit" => ["can't be blank"]}]
      }
    }
  end
  end

  describe "update set" do
    @tag :authenticated
    test "update changes an exercise record and renders a list of exercises when called with valid attributes", %{conn: conn} do
      set = Factory.insert(:set)
      exercise = Factory.insert(:exercise)

      conn = put conn, Routes.session_set_path(conn, :update, set.session_id, set), set: %{
        name: "New set name",
        set_exercises: %{
          "0" => %{
            unit: "Time",
            exercise_id: exercise.id
          }
        }
      }

      updated_set = Sessions.get_set!(set.id)
      updated_set_name = updated_set.name
      updated_set_id = updated_set.id
      assert %{
        "set" => %{
          "name" => ^updated_set_name,
          "id" => ^updated_set_id,
          "set_exercises" => set_exercises
        },
        "message" => "Set updated"
      } = json_response(conn, 200)
    end

    @tag :authenticated
    test "#update returns a list of errors when called with invalid attributes", %{conn: conn} do
      set = Factory.insert(:set)

      conn = put conn, Routes.session_set_path(conn, :update, set.session_id, set, set: %{
        name: "",
        session_id: set.session_id,
        set_exercises: %{
          "0" => %{
            unit: "",
            exercise_id: ""
          }
        }
      })

      updated_set = Sessions.get_set!(set.id)

      assert updated_set.name == set.name
      assert updated_set.session_id == set.session_id

      assert json_response(conn, 200) == %{
        "errors" => %{
          "name" => ["can't be blank"],
          "set_exercises" => [%{}, %{"unit" => ["can't be blank"]}]
        }
      }
    end
  end

  @tag :authenticated
  test "#delete removes a set record and set exercise joins and returns a list of sets", %{conn: conn} do
    set = Factory.insert(:set)

    conn = delete conn, Routes.session_set_path(conn, :delete, set.session_id, set)

    sets = Sessions.list_sets(set.session_id)

    assert sets == []

    assert json_response(conn, 200) == %{
      "set" => %{
        "name" => set.name,
        "id" => set.id
      },
      "message" => "Set deleted"
    }
  end
end
