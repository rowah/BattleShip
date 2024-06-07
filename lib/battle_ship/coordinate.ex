defmodule BattleShip.Coordinate do
  @moduledoc """
  This is the Coordinate module. It returns a tuple of atom :ok and a coordinate struct with a row and columns keys with values of between 1 and 10
  """
  alias __MODULE__

  @board_range 1..10
  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @type t :: %Coordinate{
          row: 1..10,
          col: 1..10
        }

  @spec new(integer(), integer()) ::
          {:error, :invalid_coordinate}
          | {:ok, t()}
  def new(row, col) when row in @board_range and col in @board_range,
    do: {:ok, %Coordinate{row: row, col: col}}

  def new(_row, _col), do: {:error, :invalid_coordinate}
end
