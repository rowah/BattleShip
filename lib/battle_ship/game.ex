defmodule BattleShip.Game do
  @moduledoc false

  use GenServer

  alias BattleShip.{Board, Coordinate, Guesses, Rules, Ship}

  @players [:player1, :player2]

  @spec via_tuple(String.t()) :: {:via, Registry, {Registry.Game, String.t()}}
  def via_tuple(name), do: {:via, Registry, {Registry.Game, name}}

  @spec start_link(binary()) :: {:ok, pid()} | :ignore
  def start_link(name) when is_binary(name) do
    case GenServer.start_link(__MODULE__, name, name: via_tuple(name)) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, _pid}} ->
        :ignore
    end
  end

  @spec init(String.t()) ::
          {:ok,
           %{
             player1: %{board: map(), guesses: map(), name: String.t()},
             player2: %{board: map(), guesses: map(), name: nil},
             rules: struct()
           }}
  def init(name) do
    player1 = %{name: name, board: Board.new(), guesses: Guesses.new()}
    player2 = %{name: nil, board: Board.new(), guesses: Guesses.new()}
    {:ok, %{player1: player1, player2: player2, rules: %Rules{}}}
  end

  @spec add_player(pid(), binary()) :: :error | {:reply, :ok, %{}}
  def add_player(game, name) when is_binary(name), do: GenServer.call(game, {:add_player, name})

  def position_ship(game, player, ship_key, row, col) when player in @players,
    do: GenServer.call(game, {:position_ship, player, ship_key, row, col})

  def set_ships(game, player) when player in @players,
    do: GenServer.call(game, {:set_ships, player})

  @spec guess_coordinate(
          pid(),
          atom(),
          integer(),
          integer()
        ) :: :error | {:reply, :ok, %{}}
  def guess_coordinate(game, player, row, col) when player in @players,
    do: GenServer.call(game, {:guess_coordinate, player, row, col})

  def handle_call({:guess_coordinate, player, row, col}, _from, state_data) do
    opponent = opponent(player)
    opponent_board = player_board(state_data, opponent)

    with {:ok, rules} <- Rules.check(state_data.rules, {:guess_coordinate, player}),
         {:ok, coordinate} <- Coordinate.new(row, col),
         {hit_or_miss, sunk_ship, win_status, opponent_board} <-
           Board.guess(opponent_board, coordinate),
         {:ok, rules} <- Rules.check(rules, {:win_check, win_status}) do
      state_data
      |> update_board(opponent, opponent_board)
      |> update_guesses(player, coordinate, hit_or_miss)
      |> update_rules(rules)
      |> reply_success({hit_or_miss, sunk_ship, win_status})
    else
      :error ->
        {:reply, :error, state_data}

      {:error, :invalid_coordinate} ->
        {:reply, {:error, :invalid_coordinate}, state_data}
    end
  end

  def handle_call({:set_ships, player}, _from, state_data) do
    board = player_board(state_data, player)

    with {:ok, rules} <- Rules.check(state_data.rules, {:set_ships, player}),
         true <- Board.all_ships_set?(board) do
      state_data
      |> update_rules(rules)
      |> reply_success({:ok, board})
    else
      :error -> {:reply, :error, state_data}
      false -> {:reply, {:error, :not_all_ships_set}, state_data}
    end
  end

  def handle_call({:add_player, name}, _from, state_data) do
    case Rules.check(state_data.rules, :add_player) do
      {:ok, rules} ->
        state_data
        |> update_player2_name(name)
        |> update_rules(rules)
        |> reply_success(:ok)

      :error ->
        {:noreply, :error, state_data}
    end
  end

  def handle_call({:position_ship, player, ship_key, row, col}, _from, state_data) do
    board = player_board(state_data, player)

    with {:ok, rules} <- Rules.check(state_data.rules, {:position_ships, player}),
         {:ok, coordinate} <- Coordinate.new(row, col),
         {:ok, ship} <- Ship.new(ship_key, coordinate),
         %{} = board <- Board.position_ship(board, ship_key, ship) do
      state_data
      |> update_board(player, board)
      |> update_rules(rules)
      |> reply_success(:ok)
    else
      :error ->
        {:reply, :error, state_data}

      {:error, :invalid_coordinate} ->
        {:reply, {:error, :invalid_coordinate}, state_data}

      {:error, :invalid_ship_type} ->
        {:reply, {:error, :invalid_ship_type}, state_data}

      {:error, :overlapping_ship} ->
        {:reply, {:error, :overlapping_ship}, state_data}
    end
  end

  defp update_player2_name(state_data, name), do: put_in(state_data.player2.name, name)

  defp update_rules(state_data, rules), do: %{state_data | rules: rules}

  defp reply_success(state_data, reply), do: {:reply, reply, state_data}

  defp update_board(state_data, player, board),
    do: Map.update!(state_data, player, fn player -> %{player | board: board} end)

  defp player_board(state_data, player), do: Map.get(state_data, player).board

  defp opponent(:player1), do: :player2
  defp opponent(:player2), do: :player1

  defp update_guesses(state_data, player, coordinate, hit_or_miss) do
    update_in(state_data[player].guesses, fn guesses ->
      Guesses.add(guesses, hit_or_miss, coordinate)
    end)
  end
end
