defmodule Midgard.TeamTest do
  use Midgard.DataCase

  alias Midgard.Team

  describe "players" do
    alias Midgard.Team.Player

    @valid_attrs %{
      latitude: 120.5,
      longitude: 120.5,
      status: "some status",
      username: "someusername"
    }
    @update_attrs %{
      latitude: 456.7,
      longitude: 456.7,
      status: "some updated status",
      username: "updatedusername"
    }
    @invalid_attrs %{latitude: nil, longitude: nil, status: nil, username: nil}

    def player_fixture(attrs \\ %{}) do
      {:ok, player} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Team.create_player()

      player
    end

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Team.list_players() == [player]
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      assert Team.get_player!(player.id) == player
    end

    test "create_player/1 with valid data creates a player" do
      assert {:ok, %Player{} = player} = Team.create_player(@valid_attrs)
      assert player.latitude == 120.5
      assert player.longitude == 120.5
      assert player.status == "some status"
      assert player.username == "someusername"
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Team.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()
      assert {:ok, %Player{} = player} = Team.update_player(player, @update_attrs)
      assert player.latitude == 456.7
      assert player.longitude == 456.7
      assert player.status == "some updated status"
      assert player.username == "updatedusername"
    end

    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Team.update_player(player, @invalid_attrs)
      assert player == Team.get_player!(player.id)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Team.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Team.get_player!(player.id) end
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Team.change_player(player)
    end
  end
end
