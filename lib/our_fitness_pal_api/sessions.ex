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

  alias OurFitnessPalApi.Sessions.Set

  @doc """
  Returns the list of sets.

  ## Examples

      iex> list_sets()
      [%Set{}, ...]

  """
  def list_sets do
    Repo.all(Set)
  end

  @doc """
  Gets a single set.

  Raises `Ecto.NoResultsError` if the Set does not exist.

  ## Examples

      iex> get_set!(123)
      %Set{}

      iex> get_set!(456)
      ** (Ecto.NoResultsError)

  """
  def get_set!(id), do: Repo.get!(Set, id)

  @doc """
  Creates a set.

  ## Examples

      iex> create_set(%{field: value})
      {:ok, %Set{}}

      iex> create_set(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_set(attrs \\ %{}) do
    %Set{}
    |> Set.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a set.

  ## Examples

      iex> update_set(set, %{field: new_value})
      {:ok, %Set{}}

      iex> update_set(set, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_set(%Set{} = set, attrs) do
    set
    |> Set.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a set.

  ## Examples

      iex> delete_set(set)
      {:ok, %Set{}}

      iex> delete_set(set)
      {:error, %Ecto.Changeset{}}

  """
  def delete_set(%Set{} = set) do
    Repo.delete(set)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking set changes.

  ## Examples

      iex> change_set(set)
      %Ecto.Changeset{data: %Set{}}

  """
  def change_set(%Set{} = set, attrs \\ %{}) do
    Set.changeset(set, attrs)
  end
end
