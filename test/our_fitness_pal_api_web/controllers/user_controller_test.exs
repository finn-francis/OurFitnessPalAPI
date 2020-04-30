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
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
