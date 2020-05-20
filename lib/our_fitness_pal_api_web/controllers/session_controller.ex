defmodule OurFitnessPalApiWeb.SessionController do
  use OurFitnessPalApiWeb, :controller

  import Ecto.Query, warn: false

  alias OurFitnessPalApi.Sessions

  action_fallback OurFitnessPalApiWeb.FallbackController

  def index(conn, _params) do
    sessions = Sessions.list_sessions(current_user(conn))
    render(conn, "index.json", sessions: sessions)
  end

  def create(conn, %{"session" => session_params}) do
    case Sessions.create_session(session_params, current_user(conn)) do
      {:ok, session} ->
        render conn, "show.json", session: session, message: "Session created"
      {:error, changeset} ->
        render conn, "errors.json", changeset: changeset
    end
  end

  def show(conn, %{"id" => id}) do
    session = Sessions.get_session!(id, current_user(conn).id)
    render(conn, "show.json", session: session)
  end

  def update(conn, %{"id" => id, "session" => session_params}) do
    session = Sessions.get_session!(id, current_user(conn).id)

    case Sessions.update_session(session, session_params) do
      {:ok, session} ->
        render(conn, "show.json", session: session)
      {:error, changeset} ->
        render conn, "errors.json", changeset: changeset
    end
  end

  def delete(conn, %{"id" => id}) do
    session = Sessions.get_session!(id, current_user(conn).id)

    with {:ok, session} <- Sessions.delete_session(session) do
      render(conn, "show.json", session: session)
    end
  end
end
