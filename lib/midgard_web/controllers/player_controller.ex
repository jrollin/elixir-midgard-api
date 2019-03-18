defmodule MidgardWeb.PlayerController do
  use MidgardWeb, :controller

  alias Midgard.Team
  alias Midgard.Team.Player

  action_fallback MidgardWeb.FallbackController

  use PhoenixSwagger

  def swagger_definitions do
    %{
      Player:
        swagger_schema do
          title("Player")
          description("A player of the app")

          properties do
            id(:integer, "Player ID")
            username(:string, "Player username", required: true)
            status(:string, "Player address", required: true)
            latitude(:float, "Player latitude", required: true)
            longitude(:float, "Player longitude", required: true)
          end

          example(%{
            id: 123,
            username: "Joe",
            status: "Ready !",
            latitude: 0.7265072451,
            longitude: 0.2344109292
          })
        end,
      PlayerRequest:
        swagger_schema do
          title("PlayerRequest")
          description("POST body for creating a player")
          property(:player, Schema.ref(:Player), "The player details")
        end,
      PlayerResponse:
        swagger_schema do
          title("PlayerResponse")
          description("Response schema for single player")
          property(:data, Schema.ref(:Player), "The player details")
        end,
      PlayersResponse:
        swagger_schema do
          title("PlayersReponse")
          description("Response schema for multiple players")
          property(:data, Schema.array(:Player), "The players details")
        end
    }
  end

  swagger_path(:index) do
    get("/api/players")
    summary("List Players")
    description("List all players in the database")
    produces("application/json")
    deprecated(false)

    response(200, "OK", Schema.ref(:PlayersResponse),
      example: %{
        data: [
          %{
            id: 1,
            username: "Joe",
            status: "Ready !",
            latitude: 0.7265072451,
            longitude: 0.2344109292
          },
          %{
            id: 2,
            username: "Jack",
            status: "Waiting...",
            latitude: 0.3365072451,
            longitude: 0.5444109292
          }
        ]
      }
    )
  end

  def index(conn, _params) do
    players = Team.list_players()
    render(conn, "index.json", players: players)
  end

  def create(conn, %{"player" => player_params}) do
    with {:ok, %Player{} = player} <- Team.create_player(player_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.player_path(conn, :show, player))
      |> render("show.json", player: player)
    end
  end

  swagger_path(:show) do
    summary("Show Player")
    description("Show a player by ID")
    produces("application/json")
    parameter(:id, :path, :integer, "Player ID", required: true, example: 123)

    response(200, "OK", Schema.ref(:PlayerResponse),
      example: %{
        data: %{
          id: 123,
          username: "Joe",
          status: "Ready !",
          latitude: 0.7265072451,
          longitude: 0.2344109292
        }
      }
    )
  end

  def show(conn, %{"id" => id}) do
    player = Team.get_player!(id)
    render(conn, "show.json", player: player)
  end

  def update(conn, %{"id" => id, "player" => player_params}) do
    player = Team.get_player!(id)

    with {:ok, %Player{} = player} <- Team.update_player(player, player_params) do
      render(conn, "show.json", player: player)
    end
  end

  def delete(conn, %{"id" => id}) do
    player = Team.get_player!(id)

    with {:ok, %Player{}} <- Team.delete_player(player) do
      send_resp(conn, :no_content, "")
    end
  end
end
