defmodule BattleShip.DemoProc do
  @moduledoc false
  def loop do
    receive do
      msg -> IO.puts("I received message: #{msg}")
    end

    loop()
  end
end
