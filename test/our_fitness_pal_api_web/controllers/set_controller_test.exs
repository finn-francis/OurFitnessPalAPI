defmodule OurFitnessPalApiWeb.SetControllerTest do
  use OurFitnessPalApiWeb.ConnCase

  alias OurFitnessPalApi.Sessions
  alias OurFitnessPalApi.Sessions.Set

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:set) do
    {:ok, set} = Sessions.create_set(@create_attrs)
    set
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all sets", %{conn: conn} do
      conn = get(conn, Routes.set_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create set" do
    test "renders set when data is valid", %{conn: conn} do
      conn = post(conn, Routes.set_path(conn, :create), set: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.set_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.set_path(conn, :create), set: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update set" do
    setup [:create_set]

    test "renders set when data is valid", %{conn: conn, set: %Set{id: id} = set} do
      conn = put(conn, Routes.set_path(conn, :update, set), set: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.set_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, set: set} do
      conn = put(conn, Routes.set_path(conn, :update, set), set: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete set" do
    setup [:create_set]

    test "deletes chosen set", %{conn: conn, set: set} do
      conn = delete(conn, Routes.set_path(conn, :delete, set))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.set_path(conn, :show, set))
      end
    end
  end

  defp create_set(_) do
    set = fixture(:set)
    %{set: set}
  end
end
