defmodule OurFitnessPalApi.Factory do
  use ExMachina.Ecto, repo: OurFitnessPalApi.Repo

  def exercise_factory do
    %OurFitnessPalApi.Workouts.Exercise{
      name: sequence("exercise"),
      description: "Default Description"
    }
  end

  def session_factory do
    %OurFitnessPalApi.Sessions.Session{
      name: sequence("session"),
      description: "Default Description"
    }
  end

  def set_factory do
    %OurFitnessPalApi.Sessions.Set{
      name: sequence("set"),
      session: build(:session),
      exercises: build_list(1, :exercise)
    }
  end
end