defmodule BattleShip.GameSupervisor do
  @moduledoc false
  use Supervisor

  alias __MODULE__
  alias BattleShip.Game

  def start_link(_options), do: Supervisor.start_link(GameSupervisor, :ok, name: GameSupervisor)

  def init(:ok), do: Supervisor.init([Game], strategy: :simple_one_for_one)

  def start_game(name), do: Supervisor.start_child(GameSupervisor, [name])

  def stop_game(name) do
    Supervisor.terminate_child(GameSupervisor, pid_from_name(name))
  end

  defp pid_from_name(name) do
    name
    |> Game.via_tuple()
    |> GenServer.whereis()
  end
end
