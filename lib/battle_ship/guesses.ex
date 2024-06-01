defmodule BattleShip.Guesses do
  @moduledoc """
  This is the Guesses module.
  """
  alias BattleShip.{Coordinate, Guesses}

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  @spec new() :: struct()
  def new, do: %Guesses{hits: MapSet.new(), misses: MapSet.new()}

  @spec add(struct(), atom(), struct()) :: map()
  def add(%Guesses{} = guesses, :hit, %Coordinate{} = coordinate) do
    update_in(guesses.hits, &MapSet.put(&1, coordinate))
  end

  def add(%Guesses{} = guesses, :miss, %Coordinate{} = coordinate) do
    update_in(guesses.misses, &MapSet.put(&1, coordinate))
  end
end
