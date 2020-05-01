# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     OurFitnessPalApi.Repo.insert!(%OurFitnessPalApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias OurFitnessPalApi.Accounts

finn = %{email: "finnfrancis123@gmail.com", password: "password", password_confirmation: "password"}
  |> Accounts.find_or_create_user
ben = %{email: "benhornsby898@hotmail.co.uk", password: "password", password_confirmation: "password"}
  |> Accounts.find_or_create_user
