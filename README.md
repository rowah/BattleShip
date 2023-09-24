# IslandsEngine

![Game Design](images/image.png)

**Game Description**

The coordinates that make up the islands are the color of sand. When the player’s opponent guesses correctly and hits an island, the coordinate the opponent hits will turn green. Otherwise, it will turn black. If all the coordinates that make up an island are hit, the island is forested, and when all of a player’s islands are forested, the opponent has won the game.

**TODO: Add demo video**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `islands_engine` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:islands_engine, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/islands_engine>.
