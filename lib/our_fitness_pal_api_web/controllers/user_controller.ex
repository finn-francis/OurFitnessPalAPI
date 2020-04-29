defmodule OurFitnessPalApiWeb.UserController do
  use OurFitnessPalApiWeb, :controller

  alias OurFitnessPalApi.Accounts
  alias OurFitnessPalApi.Accounts.User

  action_fallback OurFitnessPalApiWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end
end
