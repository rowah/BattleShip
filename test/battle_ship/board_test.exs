defmodule BattleShip.BoardTest do
  use ExUnit.Case
  doctest BattleShip

  test "returns a new board" do
    assert BattleShip.Board.new() == %{}
  end
end
