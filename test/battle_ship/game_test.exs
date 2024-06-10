defmodule BattleShip.GameTest do
  use ExUnit.Case

  alias BattleShip.Game

  doctest BattleShip

  test "starts a new game and ignore an already started game" do
    assert {:ok, pid} = Game.start_link("test")

    assert is_pid(pid)

    assert :ignore = Game.start_link("test")

    GenServer.stop(pid)
  end
end
