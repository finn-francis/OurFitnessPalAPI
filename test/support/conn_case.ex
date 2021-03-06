defmodule OurFitnessPalApiWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use OurFitnessPalApiWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import OurFitnessPalApiWeb.ConnCase

      alias OurFitnessPalApiWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint OurFitnessPalApiWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(OurFitnessPalApi.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(OurFitnessPalApi.Repo, {:shared, self()})
    end

    conn = if tags[:authenticated] do
      add_user(Phoenix.ConnTest.build_conn(), tags[:user])
    else
      Phoenix.ConnTest.build_conn()
    end

    {:ok, conn: conn}
  end

  def add_user(conn, type) do
    {:ok, user} = OurFitnessPalApi.Accounts.create_user(%{
      email: "email@fake.com",
      password: "password",
      password_confirmation: "password"
    })
    OurFitnessPalApi.Guardian.Plug.sign_in(conn, user)
  end
end
