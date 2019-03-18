defmodule MidgardWeb.PlayerControllerTest do
  use MidgardWeb.ConnCase

  alias Midgard.Team
  alias Midgard.Team.Player

  @create_attrs %{
    username: "foo",
    status: "somewhere",
    latitude: 0.7265072451,
    longitude: 0.2344109292
  }
  @update_attrs %{
    username: "foo updated",
    status: "here",
    latitude: 0.5172148590,
    longitude: 0.9932918140
  }
  @invalid_attrs %{
    username: nil,
    status: nil,
    latitude: nil,
    longitude: nil
  }

  def fixture(:player) do
    {:ok, player} = Team.create_player(@create_attrs)
    player
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all players", %{conn: conn} do
      conn = get(conn, Routes.player_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show" do
    setup [:create_player]

    test "renders player if found", %{
      conn: conn,
      player: %{id: id, username: username, latitude: latitude, longitude: longitude} = player
    } do
      conn = get(conn, Routes.player_path(conn, :show, player.id))

      assert %{
               "id" => ^id,
               "username" => ^username,
               "latitude" => ^latitude,
               "longitude" => ^longitude
             } = json_response(conn, 200)["data"]
    end

    test "render 404 if not found player", %{conn: conn} do
      assert_error_sent 404, fn ->
        get(conn, Routes.player_path(conn, :show, 999))
      end
    end
  end

  describe "create player" do
    test "renders player when data is valid", %{conn: conn} do
      conn = post(conn, Routes.player_path(conn, :create), player: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.player_path(conn, :create), player: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update player" do
    setup [:create_player]

    test "renders player when data is valid", %{conn: conn, player: %Player{id: id} = player} do
      conn = put(conn, Routes.player_path(conn, :update, player), player: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.player_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, player: player} do
      conn = put(conn, Routes.player_path(conn, :update, player), player: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete player" do
    setup [:create_player]

    test "deletes chosen player", %{conn: conn, player: player} do
      conn = delete(conn, Routes.player_path(conn, :delete, player))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.player_path(conn, :show, player))
      end
    end
  end

  defp create_player(_) do
    player = fixture(:player)
    {:ok, player: player}
  end
end
