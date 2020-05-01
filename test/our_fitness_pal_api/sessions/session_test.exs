defmodule OurFitnessPalApi.Sessions.SessionTest do
  use OurFitnessPalApi.DataCase

  alias OurFitnessPalApi.Sessions
  alias OurFitnessPalApi.Sessions.Session
  alias OurFitnessPalApi.Accounts

  describe "session" do
    @valid_attrs %{description: "some description", name: "some name"}

    @user_attrs %{email: "user@email.com", password: "password", password_confirmation: "password"}

    def user_fixture do
      Accounts.create_user(@user_attrs).user
    end

    def session_fixture(attrs \\ %{}) do
      {:ok, session} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sessions.create_session(user_fixture())

      session
    end

    test "user must be present" do
      assert %Ecto.Changeset{valid?: false, errors: [user_id: {"can't be blank", _}]} = Session.changeset(%Session{}, @valid_attrs)
    end
  end
end
