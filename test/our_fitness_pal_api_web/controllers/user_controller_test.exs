defmodule OurFitnessPalApiWeb.UserControllerTest do
  use OurFitnessPalApiWeb.ConnCase

  alias OurFitnessPalApi.Accounts

  @create_attrs %{
    email: "email@fake.com",
    password: "password",
    password_confirmation: "password"
  }
  @invalid_attrs %{email: nil, password_hash: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders a jwt when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      %{"jwt" => token} = json_response(conn, 200)
      assert {:ok, claims} = OurFitnessPalApi.Guardian.decode_and_verify(token)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 200)["errors"] != %{}
    end
  end

  describe "sign in" do
    test "renders a jwt when sign information is valid", %{conn: conn} do
      fixture(:user)
      conn = post(conn, Routes.user_path(conn, :sign_in), %{user: %{email: @create_attrs.email, password: @create_attrs.password}})
      %{"jwt" => token} = json_response(conn, 200)
      assert {:ok, claims} = OurFitnessPalApi.Guardian.decode_and_verify(token)
    end

    test "renders an error if the email is incorrect", %{conn: conn} do
      fixture(:user)
      conn = post(conn, Routes.user_path(conn, :sign_in), %{user: %{email: "wrong@mail.com", password: @create_attrs.password}})
      assert json_response(conn, 401) == %{"error" => "Wrong password"}
    end

    test "renders an error if the password is incorrect", %{conn: conn} do
      fixture(:user)
      conn = post(conn, Routes.user_path(conn, :sign_in), %{user: %{email: @create_attrs.email, password: "abcdefghi"}})
      assert json_response(conn, 401) == %{"error" => "Wrong password"}
    end
  end
end
