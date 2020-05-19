defmodule OurFitnessPalApiWeb.SessionControllerTest do
  use OurFitnessPalApiWeb.ConnCase

  import Ecto.Query, warn: false

  alias OurFitnessPalApi.Sessions
  alias OurFitnessPalApi.Sessions.Session
  alias OurFitnessPalApi.Accounts
  alias OurFitnessPalApi.Repo

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
    @tag :authenticated
    test "lists all sessions for", %{conn: conn} do
      user = find_authenticated_user()
      %Session{id: id, name: name, description: description} = fixture(:session, user)
      conn = get(conn, Routes.session_path(conn, :index))
      assert [%{"id" => ^id, "description" => ^description, "name" => ^name}] = json_response(conn, 200)["sessions"]
    end
  end

  describe "create session" do
    @tag :authenticated
    test "renders session when data is valid", %{conn: conn} do
      user_id = (find_authenticated_user()).id
      conn = post(conn, Routes.session_path(conn, :create), session: @create_attrs)
      assert %{"id" => id, "name" => name, "description" => description} = json_response(conn, 200)["session"]

      assert %Session{id: ^id, name: ^name, description: ^description, user_id: ^user_id} = Sessions.get_session!(id)
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @invalid_attrs)
      assert json_response(conn, 200)["errors"] != %{}
    end
  end

  describe "show" do
    setup [:create_session]

    @tag :authenticated
    test "renders a sesson", %{conn: conn, session: session} do
      conn = get(conn, Routes.session_path(conn, :show, session))
      %{"id" => id, "name" => name, "description" => description} = json_response(conn, 200)["session"]
      assert %Session{id: ^id, name: ^name, description: ^description} = session
    end
  end

  describe "update session" do
    setup [:create_session]

    @tag :authenticated
    test "renders session when data is valid", %{conn: conn, session: session} do
      conn = put(conn, Routes.session_path(conn, :update, session), session: @update_attrs)

      assert %{
               "id" => id,
               "description" => "some updated description",
               "name" => "some updated name"
             } = json_response(conn, 200)["session"]

      updated_session = Sessions.get_session!(id)
      assert updated_session.name == @update_attrs.name
      assert updated_session.description == @update_attrs.description
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn, session: session} do
      conn = put(conn, Routes.session_path(conn, :update, session), session: @invalid_attrs)
      assert json_response(conn, 200)["errors"] != %{}
    end
  end

  describe "delete session" do
    setup [:create_session]

    @tag :authenticated
    test "deletes chosen session", %{conn: conn, session: session} do
      conn = delete(conn, Routes.session_path(conn, :delete, session))
      assert response(conn, 200)


      assert Repo.get(Session, session.id) == nil
    end
  end

  defp create_session(_) do
    session = fixture(:session)
    %{session: session}
  end

  defp find_authenticated_user do
    Accounts.User |> last |> Repo.one
  end
end
