defmodule OurFitnessPalApiWeb.Router do
  use OurFitnessPalApiWeb, :router

  alias OurFitnessPalApi.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/api/v1", OurFitnessPalApiWeb do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    post "/sign_in", UserController, :sign_in
    resources "/exercises", ExerciseController, only: [:index, :show]
  end

  scope "/api/v1", OurFitnessPalApiWeb do
    pipe_through [:api, :jwt_authenticated]

    resources "/exercises", ExerciseController, only: [:create, :update, :delete]
    resources "/sessions", SessionController, except: [:new, :edit] do
      resources "/sets", SetController, except: [:new, :edit]
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: OurFitnessPalApiWeb.Telemetry
    end
  end
end
