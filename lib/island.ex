defmodule IslandEngine.Island do
  alias IslandEngine.Coordinate

  def start_link() do
    Agent.start_link(fn -> [] end)
  end

  def replace_coordinates(island, new_coordinates) when is_list(new_coordinates) do
    Agent.update(island, fn _state -> new_coordinates end)
  end
end
