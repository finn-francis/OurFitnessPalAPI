defmodule OurFitnessPalApi.SessionsTest do
  use OurFitnessPalApi.DataCase

  alias OurFitnessPalApi.Sessions
  alias OurFitnessPalApi.Accounts

  describe "sessions" do
    alias OurFitnessPalApi.Sessions.Session

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil }

    def user_fixture do
      {:ok, user} =
        %{email: "email@email.com", password: "password", password_confirmation: "password"}
        |> Accounts.create_user()

      user
    end

    def session_fixture(attrs \\ %{}) do
      {:ok, session} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sessions.create_session(user_fixture())

      session
    end

    test "list_sessions/0 returns all sessions" do
      session = session_fixture()
      assert Sessions.list_sessions() == [session]
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
end
