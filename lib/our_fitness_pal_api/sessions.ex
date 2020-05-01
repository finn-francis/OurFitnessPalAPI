defmodule OurFitnessPalApi.Sessions do
  @moduledoc """
  The Sessions context.
  """

  import Ecto.Query, warn: false
  alias OurFitnessPalApi.Repo
  alias OurFitnessPalApi.Sessions.Session

  @doc """
  Creates a new session and attaches a user
  """
  def create_session(attrs, user) do
    user
    |> Ecto.build_assoc(:sessions, %{})
    |> Session.changeset(attrs)
    |> Repo.insert
  end
end
