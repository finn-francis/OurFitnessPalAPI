defmodule OurFitnessPalApiWeb.SessionView do
  use OurFitnessPalApiWeb, :view
  alias OurFitnessPalApiWeb.SessionView

  def render("index.json", %{sessions: sessions}) do
    %{data: render_many(sessions, SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{id: session.id,
      name: session.name,
      description: session.description}
  end
end
