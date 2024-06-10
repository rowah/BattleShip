defmodule BattleShip.Rules do
  @moduledoc """
  This is the Rules module.
  """
  alias __MODULE__

  defstruct state: :initialized,
            player1: :ships_not_set,
            player2: :ships_not_set

  @spec new() :: struct()
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
  def new, do: %Rules{}

  @spec check(struct(), atom() | tuple()) ::
          :error
          | {:ok,
             %{
               :__struct__ => BattleShip.Rules,
               :state => :game_over | :player1_turn | :player2_turn | :players_set | :ships_set,
               optional(any()) => any()
             }}
  @doc """
  Gives game rules and transitions states and actions. Pattern matches for the current game state and actions possible in that state.
  For any state/event combination that ends up in catchall, we don’t want to transition the state and so :error is returned.

  Returns `{:ok, rules}`.

  ## Examples

      iex> BattleShip.Ship.check(%Rules{state: :initialized} = rules, :add_player)
      {:ok, %Rules{rules | state: :players_set}}

  """
  def check(%Rules{state: :initialized} = rules, :add_player) do
    {:ok, %Rules{rules | state: :players_set}}
  end

  def check(%Rules{state: :players_set} = rules, {:position_ships, player}) do
    # state remains the same
    case Map.fetch!(rules, player) do
      # can no longer reposition ships
      :ships_set -> :error
      # can still reposition ships
      :ships_not_set -> {:ok, rules}
    end
  end

  def check(%Rules{state: :players_set} = rules, {:set_ships, player}) do
    # sets ships for player and moves state if both player's ships are set
    rules = Map.put(rules, player, :ships_set)

    if both_players_ships_set?(rules) do
      {:ok, %Rules{rules | state: :player1_turn}}
    else
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

  # catch all state, eg when player1 tries to guess a coordinate when the state is in player2's turn
  def check(_state, _action), do: :error

  defp both_players_ships_set?(rules), do: rules.player1 == :ships_set && rules.player2 == :ships_set
end
