defmodule MidgardWeb.PlayerView do
  use MidgardWeb, :view
  alias MidgardWeb.PlayerView

  def render("index.json", %{players: players}) do
    %{data: render_many(players, PlayerView, "player.json")}
  end

  def render("show.json", %{player: player}) do
    %{data: render_one(player, PlayerView, "player.json")}
  end

  def render("player.json", %{player: player}) do
    %{
      id: player.id,
      username: player.username,
      status: player.status,
      latitude: player.latitude,
      longitude: player.longitude
    }
  end
end
