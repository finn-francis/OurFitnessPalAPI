defmodule OurFitnessPalApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias OurFitnessPalApi.Accounts.User

  import Bcrypt, only: [hash_pwd_salt: 1]

  schema "users" do
    field :email, :string
    field :password_hash, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_many :sessions, OurFitnessPalApi.Sessions.Session

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password, message: "does not match password")
    |> unique_constraint(:email)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}}
        ->
          put_change(changeset,:password_hash, hash_pwd_salt(pass))
      _
        ->
          changeset
    end
  end
end
