defmodule OurFitnessPalApiWeb.SetController do
  use OurFitnessPalApiWeb, :controller

  alias OurFitnessPalApi.Sessions

  action_fallback OurFitnessPalApiWeb.FallbackController

  def index(conn, %{"session_id" => session_id}) do
    sets = Sessions.list_sets(session_id)
    render conn, "index.json", sets: sets, message: ""
  end

  def create(conn, %{"session_id" => session_id, "set" => set_params}) do
    # TODO: ensure that the current user owns this session
    case Sessions.create_set(session_id, set_params) do
      {:ok, set} ->
        render conn, "show.json", set: set, message: "Set created"
      {:error, changeset} ->
        render conn, "errors.json", changeset: changeset
    end
  end

  def show(conn, %{"id" => id}) do
    set = Sessions.get_set!(id)
    render(conn, "show.json", set: set)
  end

  def update(conn, %{"id" => id, "set" => set_params}) do
    # TODO: ensure that the current user owns this session
    set = Sessions.get_set!(id)

    case Sessions.update_set(set, set_params) do
      {:ok, set} ->
        render conn, "show.json", set: set, message: "Set updated"
      {:error, changeset} ->
        render conn, "errors.json", changeset: changeset
    end
  end

  def delete(conn, %{"id" => set_id}) do
    set = Sessions.get_set!(set_id)
    case Sessions.delete_set(set) do
      {:ok, set} ->
        render conn, "show.json", set: set, message: "Set deleted"
      {:error, changeset} ->
        render conn, "errors.json", changeset: changeset
    end
  end
end
