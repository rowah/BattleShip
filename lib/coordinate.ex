defmodule IslandEngine.Coordinate do
  @moduledoc """
  Coordinate struct; a new Coordinate does not belong in any island, and neither player has guessed it and so the default values are :none and false
  """
  defstruct in_island: :none, guessed?: false

  alias IslandEngine.Coordinate

  @doc """
  Agent acts as temporary server to store the coordinates (state) over longer periods. Start_link starts up and links agent process. Returns a tuple
  """
  @spec start_link :: {:error, any} | {:ok, pid} | {:already_started, pid}
  def start_link() do
    Agent.start_link(fn -> %Coordinate{} end)
  end

  @spec guessed?(atom | pid | {atom, any} | {:via, atom, any}) :: atom
  def guessed?(coordinate) do
    Agent.get(coordinate, fn state -> state.guessed? end)
  end

  @spec island(pid) :: atom | boolean
  def island(coordinate) do
    Agent.get(coordinate, fn state -> state.in_island end)
  end

  @spec in_island?(pid) :: boolean
  def in_island?(coordinate) do
    case island(coordinate) do
      :none -> false
      _ -> true
    end
  end

  @spec hit(pid) :: boolean
  def hit(coordinate) do
    in_island?(coordinate) && guessed?(coordinate)
  end

  def guess(coordinate) do
    Agent.update(coordinate, fn state -> Map.put(state, :guessed?, true) end)
  end

  def set_in_island(coordinate, value) when is_atom(value) do
    Agent.update(coordinate, fn state -> Map.put(state, :in_island, value) end)
  end

  def to_string(coordinate) do
    "(in-island:#{in_island?(coordinate)}, guessed:#{guessed?(coordinate)})"
  end
end
