defmodule BattleShip.BoardTest do
  use ExUnit.Case

  alias BattleShip.Board

  doctest BattleShip

  test "returns a new board" do
    assert Board.new() == %{}
  end
end
