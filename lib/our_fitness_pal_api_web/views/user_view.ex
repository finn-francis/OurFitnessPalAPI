defmodule OurFitnessPalApiWeb.UserView do
  use OurFitnessPalApiWeb, :view
  alias OurFitnessPalApiWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email}
  end

  def render("jwt.json", %{jwt: jwt, user: user, message: message}) do
    %{
      jwt: jwt,
      user: %{
        id: user.id,
        email: user.email
      },
      message: message
    }
  end

  def render("errors.json", %{changeset: changeset}) do
    %{errors: translate_errors(changeset)}
  end

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end
end
