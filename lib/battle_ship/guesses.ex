defmodule BattleShip.Guesses do
  @moduledoc """
  This is the Guesses module.
  """

  alias __MODULE__
  alias BattleShip.Coordinate

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  @type t :: %Guesses{
          hits: MapSet.t(),
          misses: MapSet.t()
        }

  @spec new() :: t()
  def new, do: %Guesses{hits: MapSet.new(), misses: MapSet.new()}

  @spec add(struct(), :hit | :miss, Coordinate.t()) :: t()
  def add(%Guesses{} = guesses, :hit, %Coordinate{} = coordinate) do
    update_in(guesses.hits, &MapSet.put(&1, coordinate))
  end

  def add(%Guesses{} = guesses, :miss, %Coordinate{} = coordinate) do
    update_in(guesses.misses, &MapSet.put(&1, coordinate))
  end
end
