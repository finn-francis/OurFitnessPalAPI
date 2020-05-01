defmodule OurFitnessPalApi.Sessions.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do
    field :description, :string
    field :name, :string

    belongs_to :user, OurFitnessPalApi.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description, :user_id])
  end
end
