defmodule OurFitnessPalApi.WorkoutsTest do
  use OurFitnessPalApi.DataCase

  alias OurFitnessPalApi.Workouts

  describe "exercises" do
    alias OurFitnessPalApi.Workouts.Exercise

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def exercise_fixture(attrs \\ %{}) do
      {:ok, exercise} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Workouts.create_exercise()

      exercise
    end

    test "list_exercises/0 returns all exercises" do
      exercise = exercise_fixture()
      assert Workouts.list_exercises() == [exercise]
    end

    test "get_exercise!/1 returns the exercise with given id" do
      exercise = exercise_fixture()
      assert Workouts.get_exercise!(exercise.id) == exercise
    end

    test "create_exercise/1 with valid data creates a exercise" do
      assert {:ok, %Exercise{} = exercise} = Workouts.create_exercise(@valid_attrs)
      assert exercise.description == "some description"
      assert exercise.name == "some name"
    end

    test "create_exercise/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workouts.create_exercise(@invalid_attrs)
    end

    test "update_exercise/2 with valid data updates the exercise" do
      exercise = exercise_fixture()
      assert {:ok, %Exercise{} = exercise} = Workouts.update_exercise(exercise, @update_attrs)
      assert exercise.description == "some updated description"
      assert exercise.name == "some updated name"
    end

    test "update_exercise/2 with invalid data returns error changeset" do
      exercise = exercise_fixture()
      assert {:error, %Ecto.Changeset{}} = Workouts.update_exercise(exercise, @invalid_attrs)
      assert exercise == Workouts.get_exercise!(exercise.id)
    end

    test "delete_exercise/1 deletes the exercise" do
      exercise = exercise_fixture()
      assert {:ok, %Exercise{}} = Workouts.delete_exercise(exercise)
      assert_raise Ecto.NoResultsError, fn -> Workouts.get_exercise!(exercise.id) end
    end

    test "change_exercise/1 returns a exercise changeset" do
      exercise = exercise_fixture()
      assert %Ecto.Changeset{} = Workouts.change_exercise(exercise)
    end

    test "create_exercise/1 with a repeat name returns error changeset" do
      exercise_fixture()
      assert {:error, %Ecto.Changeset{}} = Workouts.create_exercise(@valid_attrs)
    end

    test "update_exercise/2 with a repeat name returns error changeset" do
      exercise = exercise_fixture()
      Workouts.create_exercise(@update_attrs)
      assert {:error, %Ecto.Changeset{}} = Workouts.update_exercise(exercise, @update_attrs)
    end
  end
end
