defmodule IslandEngine.Guesses do
  alias __MODULE__

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  # Elixir’s MapSet data structure guarantees that each member of the MapSet will be unique to cater for the fact that a specific guess can be done more than once. A guess already made will simply be ignored by MapSet. Returns a new guesses struct.
  @spec new() :: %IslandEngine.Guesses{hits: MapSet.t(), misses: MapSet.t()}
  def new(), do: %Guesses{hits: MapSet.new(), misses: MapSet.new()}
end
