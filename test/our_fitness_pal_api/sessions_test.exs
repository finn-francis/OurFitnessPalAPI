defmodule OurFitnessPalApi.SessionsTest do
  use OurFitnessPalApi.DataCase
  require OurFitnessPalApi.Factory

  alias OurFitnessPalApi.Factory
  alias OurFitnessPalApi.Sessions
  alias OurFitnessPalApi.Accounts

  describe "sessions" do
    alias OurFitnessPalApi.Sessions.Session

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil }

    @user_attrs %{email: "email@email.com", password: "password", password_confirmation: "password"}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@user_attrs)
        |> Accounts.create_user()

      user
    end

    def session_fixture(attrs \\ %{}, user \\ user_fixture()) do
      {:ok, session} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sessions.create_session(user)

      session
    end

    test "list_sessions/0 returns all sessions" do
      session = session_fixture()
      assert Sessions.list_sessions() == [session]
    end

    test "list_sessions/1 with a user struct argument" do
      user = user_fixture()
      other_user = user_fixture(%{email: "otheruser@email.com"})
      session = session_fixture(%{}, user)
      other_session = session_fixture(%{}, other_user)

      assert [session] == Sessions.list_sessions(user)
      assert [other_session] == Sessions.list_sessions(other_user)
    end

    @tag timeout: :infinity
    test "list_sessions/1 with a user_id argument" do
      user = user_fixture()
      other_user = user_fixture(%{email: "otheruser@email.com"})
      session = session_fixture(%{}, user)
      other_session = session_fixture(%{}, other_user)

      assert [session] == Sessions.list_sessions(user.id)
      assert [other_session] == Sessions.list_sessions(other_user.id)
    end

    test "get_session!/1 returns the session with given id" do
      session = session_fixture()
      assert Sessions.get_session!(session.id) == session
    end

    test "create_session/2 with valid data creates a session" do
      assert {:ok, %Session{} = session} = Sessions.create_session(@valid_attrs, user_fixture())
      assert session.description == "some description"
      assert session.name == "some name"
    end

    test "create_session/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sessions.create_session(@invalid_attrs, user_fixture())
    end

    test "update_session/2 with valid data updates the session" do
      session = session_fixture()
      assert {:ok, %Session{} = session} = Sessions.update_session(session, @update_attrs)
      assert session.description == "some updated description"
      assert session.name == "some updated name"
    end

    test "update_session/2 with invalid data returns error changeset" do
      session = session_fixture()
      assert {:error, %Ecto.Changeset{}} = Sessions.update_session(session, @invalid_attrs)
      assert session == Sessions.get_session!(session.id)
    end

    test "delete_session/1 deletes the session" do
      session = session_fixture()
      assert {:ok, %Session{}} = Sessions.delete_session(session)
      assert_raise Ecto.NoResultsError, fn -> Sessions.get_session!(session.id) end
    end
  end

  describe "sets" do
    alias OurFitnessPalApi.Sessions.Set

    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def set_fixture() do
      Factory.insert(:set)
    end

    test "list_sets/0 returns all sets" do
      set = set_fixture()
      assert Sessions.list_sets() == [set]
    end

    test "get_set!/1 returns the set with given id" do
      set = set_fixture()
      assert Sessions.get_set!(set.id) == set
    end

    test "create_set/1 with valid data creates a set" do
      exercise = Factory.insert(:exercise)
      session = Factory.insert(:session)
      assert {:ok, %Set{} = set} = Sessions.create_set(%{
        name: "some name",
        session_id: session.id,
        set_exercises: %{
          "0" => %{
            unit: "Distance",
            exercise_id: exercise.id
          }
        }
      })

      assert set.name == "some name"
      assert set.session_id == session.id
      assert set.exercises != []
    end

    test "create_set/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sessions.create_set(@invalid_attrs)
    end

    test "update_set/2 with valid data updates the set" do
      set = set_fixture()
      assert {:ok, %Set{} = set} = Sessions.update_set(set, @update_attrs)
      assert set.name == "some updated name"
    end

    test "update_set/2 with invalid data returns error changeset" do
      set = set_fixture()
      assert {:error, %Ecto.Changeset{}} = Sessions.update_set(set, @invalid_attrs)
      assert set == Sessions.get_set!(set.id)
    end

    test "delete_set/1 deletes the set" do
      set = set_fixture()
      assert {:ok, %Set{}} = Sessions.delete_set(set)
      assert_raise Ecto.NoResultsError, fn -> Sessions.get_set!(set.id) end
    end

    test "change_set/1 returns a set changeset" do
      set = set_fixture()
      assert %Ecto.Changeset{} = Sessions.change_set(set)
    end
  end
end
