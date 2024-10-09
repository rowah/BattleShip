defmodule BattleShip.GameSupervisor do
  @moduledoc false
  use DynamicSupervisor, restart: :permanent

  alias BattleShip.Game

  def start_link(:ok), do: DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  @impl true
  def init(:ok) do
    DynamicSupervisor.init([])
  end

  def start_game(name), do: DynamicSupervisor.start_child(__MODULE__, [name])

  def stop_game(name) do
    Supervisor.terminate_child(__MODULE__, pid_from_name(name))
  end

  defp pid_from_name(name) do
    name
    |> Game.via_tuple()
    |> GenServer.whereis()
  end
end
