defmodule OurFitnessPalApi.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :our_fitness_pal_api,
  module: OurFitnessPalApi.Guardian,
  error_handler: OurFitnessPalApi.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end