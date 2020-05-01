defmodule OurFitnessPalApi.Sessions do
  @moduledoc """
  The Sessions context.
  """

  import Ecto.Query, warn: false
  alias OurFitnessPalApi.Repo
  alias OurFitnessPalApi.Sessions.Session

  @doc """
  Returns the list of sessions.
  """
  def list_sessions do
    Repo.all(Session)
  end

  def list_sessions(user) when is_map(user), do: Repo.preload(user, :sessions).sessions

  def list_sessions(user) when is_integer(user) do
    from(session in Session, where: session.user_id == ^user) |> Repo.all
  end

  @doc """
  Gets a single session.

  Raises `Ecto.NoResultsError` if the Session does not exist.
  """
  def get_session!(id), do: Repo.get!(Session, id)

  @doc """
  Creates a new session and attaches a user
  """
  def create_session(attrs, user) do
    user
    |> Ecto.build_assoc(:sessions, %{})
    |> Session.changeset(attrs)
    |> Repo.insert
  end

  @doc """
  Updates a session.
  """
  def update_session(%Session{} = session, attrs) do
    session
    |> Session.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a session.
  """
  def delete_session(%Session{} = session) do
    Repo.delete(session)
  end
end
