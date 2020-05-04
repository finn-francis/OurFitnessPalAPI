defmodule OurFitnessPalApiWeb.SessionController do
  use OurFitnessPalApiWeb, :controller

  # TODO (Finn): remove this once we have a current user plug, this is temporary to allow testing on session
  import Ecto.Query, warn: false

  alias OurFitnessPalApi.Repo
  alias OurFitnessPalApi.Sessions
  alias OurFitnessPalApi.Sessions.Session
  alias OurFitnessPalApi.Accounts.User

  action_fallback OurFitnessPalApiWeb.FallbackController

  def index(conn, _params) do
    sessions = Sessions.list_sessions()
    render(conn, "index.json", sessions: sessions)
  end

  def create(conn, %{"session" => session_params}) do
    with {:ok, %Session{} = session} <- Sessions.create_session(session_params, current_user()) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.session_path(conn, :show, session))
      |> render("show.json", session: session)
    end
  end

  def show(conn, %{"id" => id}) do
    session = Sessions.get_session!(id)
    render(conn, "show.json", session: session)
  end

  def update(conn, %{"id" => id, "session" => session_params}) do
    session = Sessions.get_session!(id)

    with {:ok, %Session{} = session} <- Sessions.update_session(session, session_params) do
      render(conn, "show.json", session: session)
    end
  end

  # TODO (Finn): remove this once we have a current user plug, this is temporary to allow testing on session
  defp current_user do
    Repo.one(from u in User, limit: 1)
  end
end
