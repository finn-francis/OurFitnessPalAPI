defmodule OurFitnessPalApiWeb.SetView do
  use OurFitnessPalApiWeb, :view

  def render("index.json", %{sets: sets, message: message}) do
    %{
      sets: Enum.map(sets, &set_json/1),
      message: message
    }
  end

  def render("show.json", %{set: set} = params) do
    message = params[:message] || ""
    %{set: set_json(set), message: message}
  end

  def render("errors.json", %{changeset: changeset}) do
    %{errors: translate_errors(changeset)}
  end

  def set_json(set) do
    %{
      id: set.id,
      name: set.name,
    }
  end

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end
end
