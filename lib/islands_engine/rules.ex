defmodule IslandEngine.Rules do
  @moduledoc """
  This is the Rules module.
  """
  alias __MODULE__

  defstruct state: :initialized

  @doc """
  Gives game rules.

  Returns ``.

  ## Examples

      iex> IslandEngine.Island.new()
      %{}

  """
  def new(), do: %Rules{}

  def check(%Rules{state: :initialized} = rules, :add_player) do
    {:ok, %Rules{rules | state: :players_set}}
  end

  @doc """
  For any state/event combination that ends up in this catchall, we don’t want to transition the state. By simply returning :error, we don’t transform the value of the :state key. Leaving it unchanged keeps the game in the same state.

  Returns ``.

  ## Examples

      iex> IslandEngine.Island.new()
      %{}

  """
  def check(_state, _action), do: :error
end
