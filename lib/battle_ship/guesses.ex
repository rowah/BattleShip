defmodule BattleShip.Guesses do
  @moduledoc """
  This is the Guesses module.
  """
  alias BattleShip.{Coordinate, Guesses}

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  # Elixir’s MapSet data structure guarantees that each member of the MapSet will be unique to cater for the fact that a specific guess can be done more than once. A guess already made will simply be ignored by MapSet. Returns a new guesses struct.
  @spec new() :: %BattleShip.Guesses{hits: MapSet.t(), misses: MapSet.t()}
  def new(), do: %Guesses{hits: MapSet.new(), misses: MapSet.new()}

  @spec add(struct(), atom(), struct()) :: map()
  def add(%Guesses{} = guesses, :hit, %Coordinate{} = coordinate) do
    update_in(guesses.hits, &MapSet.put(&1, coordinate))
  end

  def add(%Guesses{} = guesses, :miss, %Coordinate{} = coordinate) do
    update_in(guesses.misses, &MapSet.put(&1, coordinate))
  end
end
