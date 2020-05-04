defmodule OurFitnessPalApiWeb.SessionControllerTest do
  use OurFitnessPalApiWeb.ConnCase

  alias OurFitnessPalApi.Sessions
  alias OurFitnessPalApi.Sessions.Session
  alias OurFitnessPalApi.Accounts

  @create_attrs %{
    description: "some description",
    name: "some name"
  }
  @update_attrs %{
    description: "some updated description",
    name: "some updated name"
  }
  @invalid_attrs %{description: nil, name: nil}
  @user_attrs %{email: "email@email.com", password: "password", password_confirmation: "password"}

  def fixture(:session, user \\ user_fixture()) do
    {:ok, session} = Sessions.create_session(@create_attrs, user)
    session
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@user_attrs)
      |> Accounts.create_user()

    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_session]

    test "lists all sessions", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :index))
      assert [%{"description" => "some description", "name" => "some name"}] = json_response(conn, 200)["data"]
    end
  end

  defp create_session(_) do
    session = fixture(:session)
    %{session: session}
  end
end
