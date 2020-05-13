defmodule OurFitnessPalApiWeb.SetView do
  use OurFitnessPalApiWeb, :view
  alias OurFitnessPalApiWeb.SetView

  def render("index.json", %{sets: sets}) do
    %{data: render_many(sets, SetView, "set.json")}
  end

  def render("show.json", %{set: set}) do
    %{data: render_one(set, SetView, "set.json")}
  end

  def render("set.json", %{set: set}) do
    %{id: set.id,
      name: set.name}
  end
end
