defmodule Midgard.Team.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :latitude, :float
    field :longitude, :float
    field :status, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:username, :status, :latitude, :longitude])
    |> validate_required([:username, :status, :latitude, :longitude])
    |> validate_length(:username, max: 100)
    |> unique_constraint(:username)
  end
end
