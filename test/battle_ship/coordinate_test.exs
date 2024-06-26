defmodule BattleShip.CoordinateTest do
  use ExUnit.Case

  alias BattleShip.Coordinate

  doctest BattleShip

  # alias BattleShip.CoordinateFixtures

  test "create new valid and invalid coordinate" do
    assert Coordinate.new(1, 1) == {:ok, %Coordinate{row: 1, col: 1}}
    assert Coordinate.new(11, 13) == {:error, :invalid_coordinate}
  end
end
