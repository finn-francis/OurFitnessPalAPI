defmodule OurFitnessPalApiWeb.UserController do
  use OurFitnessPalApiWeb, :controller

  alias OurFitnessPalApi.Accounts
  alias OurFitnessPalApi.Accounts.User
  alias OurFitnessPalApi.Guardian

  action_fallback OurFitnessPalApiWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        case Guardian.encode_and_sign(user) do
          {:ok, token, _claims} ->
            conn |> render("jwt.json", %{jwt: token, user: %{id: user.id, email: user.email}, message: "Account created"})
        end
      {:error, changeset} ->
        render conn, "errors.json", changeset: changeset
    end
  end

  def sign_in(conn, %{"user" => %{"email" => email, "password" => password}}) do
    with {:ok, token, claims} <- Accounts.token_sign_in(email, password),
         {:ok, user} <- Guardian.resource_from_claims(claims)
    do
      conn |> render("jwt.json", %{jwt: token, user: %{id: user.id, email: user.email}, message: "Signed in succesfully"})
    else
      _ -> {:error, :unauthorized}
    end
  end
end
