defmodule BattleShip.DemoProc do
  def loop() do
    receive do
      msg -> IO.puts("I received message: #{msg}")
    end

    loop()
  end
end
