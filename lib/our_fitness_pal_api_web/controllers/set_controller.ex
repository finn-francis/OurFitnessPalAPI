defmodule OurFitnessPalApiWeb.SetController do
  use OurFitnessPalApiWeb, :controller

  alias OurFitnessPalApi.Sessions
  alias OurFitnessPalApi.Sessions.Set

  action_fallback OurFitnessPalApiWeb.FallbackController

  def index(conn, _params) do
    sets = Sessions.list_sets()
    render(conn, "index.json", sets: sets)
  end

  def create(conn, %{"set" => set_params}) do
    with {:ok, %Set{} = set} <- Sessions.create_set(set_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.set_path(conn, :show, set))
      |> render("show.json", set: set)
    end
  end

  def show(conn, %{"id" => id}) do
    set = Sessions.get_set!(id)
    render(conn, "show.json", set: set)
  end

  def update(conn, %{"id" => id, "set" => set_params}) do
    set = Sessions.get_set!(id)

    with {:ok, %Set{} = set} <- Sessions.update_set(set, set_params) do
      render(conn, "show.json", set: set)
    end
  end

  def delete(conn, %{"id" => id}) do
    set = Sessions.get_set!(id)

    with {:ok, %Set{}} <- Sessions.delete_set(set) do
      send_resp(conn, :no_content, "")
    end
  end
end
