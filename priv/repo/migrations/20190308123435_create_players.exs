defmodule Midgard.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :username, :string
      add :status, :string
      add :latitude, :float
      add :longitude, :float

      timestamps()
    end

    create unique_index(:players, [:username])
  end
end
