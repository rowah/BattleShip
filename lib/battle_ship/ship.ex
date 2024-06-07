defmodule BattleShip.Ship do
  @moduledoc """
  This is the Ship module.
  """
  alias BattleShip.{Coordinate, Ship}

  @enforce_keys [:coordinates, :hit_coordinates]
  defstruct [:coordinates, :hit_coordinates]

  @doc """
  Gives a game board.

  Returns `%{:ok, %BattleShip.Ship{}}`.

  ## Examples

      iex> BattleShip.Ship.new()
      %{}

  """
  def new(type, %Coordinate{} = upper_left) do
    with [_ | _] = offsets <- offset(type),
         %MapSet{} = coordinates <- add_coordinates(offsets, upper_left) do
      {:ok, %Ship{coordinates: coordinates, hit_coordinates: MapSet.new()}}
    else
      error ->
        error
    end
  end

  defp offset(:square), do: [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
  defp offset(:atoll), do: [{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 1}]
  defp offset(:dot), do: [{0, 0}]
  defp offset(:l_shape), do: [{0, 0}, {1, 0}, {2, 0}, {2, 1}]
  defp offset(:s_shape), do: [{0, 1}, {0, 2}, {1, 0}, {1, 1}]
  defp offset(_), do: {:error, :invalid_ship_type}

  defp add_coordinates(offsets, upper_left) do
    Enum.reduce_while(offsets, MapSet.new(), fn offset, acc ->
      add_coordinate(acc, upper_left, offset)
    end)
  end

  defp add_coordinate(coordinates, %Coordinate{row: row, col: col}, {row_offset, col_offset}) do
    case Coordinate.new(row + row_offset, col + col_offset) do
      {:ok, coordinate} ->
        {:cont, MapSet.put(coordinates, coordinate)}

      {:error, :invalid_coordinate} ->
        {:halt, {:error, :invalid_coordinate}}
    end
  end

  @spec overlaps?(struct(), struct()) :: boolean()
  def overlaps?(existing_ship, new_ship),
    do: not MapSet.disjoint?(existing_ship.coordinates, new_ship.coordinates)

  @spec guess(struct(), struct()) ::
          :miss
          | {:hit,
             %{
               :coordinates => MapSet.t(),
               :hit_coordinates => MapSet.t(),
               optional(any()) => any()
             }}
  def guess(ship, coordinate) do
    case MapSet.member?(ship.coordinates, coordinate) do
      true ->
        hit_coordinates = MapSet.put(ship.hit_coordinates, coordinate)
        {:hit, %{ship | hit_coordinates: hit_coordinates}}

      false ->
        :miss
    end
  end

  @spec sunk?(
          atom()
          | %{
              :coordinates => MapSet.t(),
              :hit_coordinates => MapSet.t(),
              optional(any()) => any()
            }
        ) :: boolean()
  def sunk?(ship), do: MapSet.equal?(ship.coordinates, ship.hit_coordinates)

  @spec types() :: [:atoll | :dot | :l_shape | :s_shape | :square]
  def types, do: [:atoll, :dot, :l_shape, :s_shape, :square]
end
