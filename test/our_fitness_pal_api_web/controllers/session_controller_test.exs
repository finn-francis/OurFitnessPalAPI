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

    test "lists all sessions", %{conn: conn, session: %Session{id: id, name: name, description: description}} do
      conn = get(conn, Routes.session_path(conn, :index))
      assert [%{"id" => ^id, "description" => ^description, "name" => ^name}] = json_response(conn, 200)["data"]
    end
  end

  describe "create session" do
    setup [:create_user]

    test "renders session when data is valid", %{conn: conn, user: %{id: user_id}} do
      conn = post(conn, Routes.session_path(conn, :create), session: @create_attrs)
      assert %{"id" => id, "name" => name, "description" => description} = json_response(conn, 201)["data"]

      assert %Session{id: ^id, name: ^name, description: ^description, user_id: ^user_id} = Sessions.get_session!(id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show" do
    setup [:create_session]

    test "renders a sesson", %{conn: conn, session: session} do
      conn = get(conn, Routes.session_path(conn, :show, session))
      %{"id" => id, "name" => name, "description" => description} = json_response(conn, 200)["data"]
      assert %Session{id: ^id, name: ^name, description: ^description} = session
    end
  end

  describe "update session" do
    setup [:create_session]

    test "renders session when data is valid", %{conn: conn, session: %Session{id: id} = session} do
      conn = put(conn, Routes.session_path(conn, :update, session), session: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.session_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, session: session} do
      conn = put(conn, Routes.session_path(conn, :update, session), session: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete session" do
    setup [:create_session]

    test "deletes chosen session", %{conn: conn, session: session} do
      conn = delete(conn, Routes.session_path(conn, :delete, session))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.session_path(conn, :show, session))
      end
    end
  end

  defp create_session(_) do
    session = fixture(:session)
    %{session: session}
  end

  defp create_user(_) do
    %{user: user_fixture()}
  end
end
