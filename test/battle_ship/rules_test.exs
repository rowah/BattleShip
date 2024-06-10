defmodule BattleShip.RulesTest do
  use ExUnit.Case

  doctest BattleShip

  test "create a new set of rules" do
    assert BattleShip.Rules.new() == %BattleShip.Rules{}
  end
end
