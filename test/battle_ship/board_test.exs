defmodule BattleShip.BoardTest do
  use ExUnit.Case
  doctest BattleShip

  alias BattleShip.Board

  test "returns a new board" do
    assert Board.new() == %{}
  end
end
