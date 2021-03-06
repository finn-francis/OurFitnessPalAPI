defmodule OurFitnessPalApiWeb.SessionView do
  use OurFitnessPalApiWeb, :view
  alias OurFitnessPalApiWeb.SessionView

  def render("index.json", %{sessions: sessions}) do
    %{sessions: render_many(sessions, SessionView, "session.json")}
  end

  def render("show.json", %{session: session}) do
    %{session: render_one(session, SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{id: session.id,
      name: session.name,
      description: session.description}
  end

  def render("errors.json", %{changeset: changeset}) do
   %{errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)}
  end
end
