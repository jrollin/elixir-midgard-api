defmodule Midgard.DatabaseSeeder do
  alias Faker.{Lorem, Superhero}

  def seed(number) do
    Enum.each(1..number, fn i ->
      player_params = %{
        username: Superhero.name() <> "#{i}",
        status: Lorem.Shakespeare.as_you_like_it(),
        latitude: :rand.uniform(),
        longitude: :rand.uniform()
      }

      case Midgard.Team.create_player(player_params) do
        {:error, %{valid?: false, errors: errors}} ->
          IO.inspect(errors)
        _ ->
          nil
      end
    end)
  end
end
