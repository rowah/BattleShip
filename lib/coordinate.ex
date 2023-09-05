defmodule IslandEngine.Coordinate do
  @moduledoc """
  Coordinate struct; a new Coordinate does not belong in any island, and neither player has guessed it and so the default values are :none and false
  """
  defstruct in_island: :none, guessed?: false

  alias IslandEngine.Coordinate

  @spec start_link :: {:error, any} | {:ok, pid} | {:already_started, pid}
  @doc """
  Agent acts as temporary server to store the coordinates (state) over longer periods. Start_link starts up and links agent process
  """
  def start_link() do
    Agent.start_link(fn -> %Coordinate{} end)
  end

  @spec guessed?(atom | pid | {atom, any} | {:via, atom, any}) :: atom
  def guessed?(coordinate) do
    Agent.get(coordinate, fn state -> state.guess? end)
  end

  def island(coordinate) do
    Agent.get(coordinate, fn state -> state.in_island end)
  end
end
