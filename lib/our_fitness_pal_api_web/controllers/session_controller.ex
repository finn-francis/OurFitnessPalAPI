defmodule OurFitnessPalApiWeb.SessionController do
  use OurFitnessPalApiWeb, :controller

  alias OurFitnessPalApi.Sessions
  alias OurFitnessPalApi.Sessions.Session

  action_fallback OurFitnessPalApiWeb.FallbackController

  def index(conn, _params) do
    sessions = Sessions.list_sessions()
    render(conn, "index.json", sessions: sessions)
  end
end
