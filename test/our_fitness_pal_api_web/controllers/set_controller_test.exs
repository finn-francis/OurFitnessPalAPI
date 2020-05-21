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
      set = Factory.insert(:set)

      conn = get conn, Routes.session_set_path(conn, :index, set.session_id)

      assert json_response(conn, 200) == %{
        "sets" => [%{
          "id" => set.id,
          "name" => set.name
        }],
        "message" => ""
      }
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

      assert json_response(conn, 200) == %{
        "set" => %{
          "name" => set.name,
          "id" => set.id
        },
        "message" => "Set created"
      }
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

      assert json_response(conn, 200) == %{
        "set" => %{
          "name" => updated_set.name,
          "id" => updated_set.id
        },
        "message" => "Set updated"
      }
      assert updated_set.name == "New set name"

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
