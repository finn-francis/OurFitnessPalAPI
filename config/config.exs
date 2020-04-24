# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :our_fitness_pal_api,
  ecto_repos: [OurFitnessPalApi.Repo]

# Configures the endpoint
config :our_fitness_pal_api, OurFitnessPalApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hRO0Jn26XOWZFay0WWBZCr70irWr8Y9IVYPL1BHszbgarzOnLwpNcpLqQV5+dSgm",
  render_errors: [view: OurFitnessPalApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: OurFitnessPalApi.PubSub,
  live_view: [signing_salt: "2LeMdpMc"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
