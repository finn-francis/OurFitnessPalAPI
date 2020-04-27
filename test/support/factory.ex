defmodule OurFitnessPalApi.Factory do
  use ExMachina.Ecto, repo: OurFitnessPalApi.Repo

  def exercise_factory do
    %OurFitnessPalApi.Workouts.Exercise{
      name: sequence("exercise"),
      description: "Default Description"
    }
  end
end