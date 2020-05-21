defmodule OurFitnessPalApiWeb.SessionController do
  use OurFitnessPalApiWeb, :controller

  import Ecto.Query, warn: false

  alias OurFitnessPalApi.Sessions
  alias OurFitnessPalApi.Sessions.Session

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
    case Sessions.get_session!(id, current_user(conn).id) do
      nil -> {:error, :forbidden}
      session -> render(conn, "show.json", session: session)
    end
  end

  def update(conn, %{"id" => id, "session" => session_params}) do
    with {:find, %Session{} = session} <- {:find, Sessions.get_session!(id, current_user(conn).id)},
         {:update, {:ok, session}}     <- {:update, Sessions.update_session(session, session_params)}
    do
      render(conn, "show.json", session: session)
    else
      {:find, _}                     -> {:error, :forbidden}
      {:update, {:error, changeset}} -> render(conn, "errors.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:find, %Session{} = session} <- {:find, Sessions.get_session!(id, current_user(conn).id)},
         {:delete, {:ok, session}}     <- {:delete, Sessions.delete_session(session)}
    do
      render(conn, "show.json", session: session)
    else
      {:find, _}                     -> {:error, :forbidden}
      {:delete, {:error, changeset}} -> render(conn, "errors.json", changeset: changeset)
    end
  end
end
