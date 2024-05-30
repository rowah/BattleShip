defmodule BattleShip.ShipTest do
  use ExUnit.Case
  doctest BattleShip

  alias BattleShip.Coordinate
  alias BattleShip.Ship

  test "create new ship with valid coordinates" do
    dot_ship_type = :dot
    {:ok, valid_dot_coordinates} = Coordinate.new(1, 1)

    assert Ship.new(dot_ship_type, valid_dot_coordinates) ==
             {:ok,
              %Ship{
                coordinates: MapSet.new([%BattleShip.Coordinate{row: 1, col: 1}]),
                hit_coordinates: MapSet.new()
              }}
  end
end
