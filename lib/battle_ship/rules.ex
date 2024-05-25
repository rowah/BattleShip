defmodule BattleShip.Rules do
  @moduledoc """
  This is the Rules module.
  """
  alias __MODULE__

  defstruct state: :initialized,
            player1: :ships_not_set,
            player2: :ships_not_set

  @spec new() :: %BattleShip.Rules{
          player1: :ships_not_set,
          player2: :ships_not_set,
          state: :initialized
        }
  @doc """
  Gives game rules.

  Returns `%Rules{}`.

  ## Examples

      iex> BattleShip.Ship.new()
      %BattleShip.Rules{
      state: :initialized,
      player1: :ships_not_set,
      player2: :ships_not_set
      }

  """
  def new(), do: %Rules{}

  @doc """
  Gives game rules and transitions states and actions. Pattern matches for the current game state and actions possible in that state. For any state/event combination that ends up in catchall, we don’t want to transition the state.

  Returns `{:ok, rules}`.

  ## Examples

      iex> BattleShip.Ship.check(%Rules{state: :initialized} = rules, :add_player)
      {:ok, %Rules{rules | state: :players_set}}

  """
  def check(%Rules{state: :initialized} = rules, :add_player) do
    # It makes a decision about whether it’s okay to add another player based on the current state of the game. Does not actually add a player. Calling the check/2 function with :add_player when we’re in the :initialized state returns {:ok, <new rules>} and moves us into the :players_set state
    {:ok, %Rules{rules | state: :players_set}}
  end

  def check(%Rules{state: :players_set} = rules, {:position_ships, player}) do
    case Map.fetch!(rules, player) do
      # If the value for the player key is :ships_not_set, it’s fine for that player to move her ships, so we return {:ok, rules}. If the values is :ships_set, it’s not okay for her to move her ships, so we return :error
      :ships_set -> :error
      :ships_not_set -> {:ok, rules}
    end
  end

  def check(%Rules{state: :players_set} = rules, {:set_ships, player}) do
    rules = Map.put(rules, player, :ships_set)

    case both_players_ships_set?(rules) do
      true ->
        {:ok, %Rules{rules | state: :player1_turn}}

      false ->
        {:ok, rules}
    end
  end

  def check(%Rules{state: :player1_turn} = rules, {:guess_coordinate, :player1}),
    do: {:ok, %Rules{rules | state: :player2_turn}}

  def check(%Rules{state: :player1_turn} = rules, {:win_check, win_or_not}) do
    case win_or_not do
      :no_win -> {:ok, rules}
      :win -> {:ok, %Rules{rules | state: :game_over}}
    end
  end

  def check(%Rules{state: :player2_turn} = rules, {:guess_coordinate, :player2}),
    do: {:ok, %Rules{rules | state: :player1_turn}}

  def check(%Rules{state: :player2_turn} = rules, {:win_check, win_or_not}) do
    case win_or_not do
      :no_win -> {:ok, rules}
      :win -> {:ok, %Rules{rules | state: :game_over}}
    end
  end

  def check(_state, _action), do: :error

  defp both_players_ships_set?(rules),
    do: rules.player1 == :ships_set && rules.player2 == :ships_set
end
