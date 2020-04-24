defmodule OurFitnessPalApi.Repo do
  use Ecto.Repo,
    otp_app: :our_fitness_pal_api,
    adapter: Ecto.Adapters.Postgres
end
