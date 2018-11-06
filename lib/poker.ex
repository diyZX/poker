defmodule Poker do
  defdelegate play(input), to: Poker.CLI
end
