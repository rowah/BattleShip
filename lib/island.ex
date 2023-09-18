defmodule IslandEngine.Island do
  alias IslandEngine.{Coordinate, Island}

  @enforce_keys [:coordinates, :hit_coordinates]
  defstruct [:coordinates, :hit_coordinates]

  def new(), do:
    %Island{coordinates: MapSet.new(), hit_coordinates: MapSet.new()}
end
