defmodule OurFitnessPalApi.AccountsTest do
  use OurFitnessPalApi.DataCase

  alias OurFitnessPalApi.Accounts

  describe "users" do
    alias OurFitnessPalApi.Accounts.User

    @valid_attrs %{email: "email@email.com", password: "password", password_confirmation: "password"}
    @update_attrs %{email: "updated.email@email.com"}
    @blank_attrs %{email: nil, password: nil, password_confirmation: ""}
    @too_short_password_attrs %{email: "email@email.com", password: "passwor", password_confirmation: "passwor"}
    @not_matching_confirmation_attrs %{email: "email@email.com", password: "password", password_confirmation: "password1"}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users without their password" do
      user = user_fixture()
      assert Accounts.list_users() == [{user.id, user.email, user.inserted_at, user.updated_at}]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == {user.id, user.email, user.inserted_at, user.updated_at}
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == @valid_attrs.email
      assert user.password_hash != @valid_attrs.password
    end

    test "create_user/1 with blank attributes returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@blank_attrs)
    end

    test "create_user/1 with too short password attributes returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@too_short_password_attrs)
    end

    test "create_user/1 password fields that don't match returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@not_matching_confirmation_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == @update_attrs.email
    end

    test "update_user/2 with blank attributes returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @blank_attrs)
      {_, user_email, _, _} = Accounts.get_user!(user.id)
      assert user.email == user_email
    end

    test "update_user/2 with too short password attributes returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @too_short_password_attrs)
      {_, user_email, _, _} = Accounts.get_user!(user.id)
      assert user.email == user_email
    end

    test "update_user/2 with password fields that don't match returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @not_matching_confirmation_attrs)
      {_, user_email, _, _} = Accounts.get_user!(user.id)
      assert user.email == user_email
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "find_or_create_user with an existing user returns the current user" do
      user = Repo.get!(User, user_fixture().id)
      original_count = Repo.aggregate(User, :count)

      assert {:ok, user} == Accounts.find_or_create_user(@valid_attrs)
      assert Repo.aggregate(User, :count) == original_count
    end

    test "find_or_create_user without an existing user creates a new user" do
      original_count = Repo.aggregate(User, :count)

      assert {:ok, user} = Accounts.find_or_create_user(@valid_attrs)
      assert Repo.aggregate(User, :count) == original_count + 1
    end
  end
end
