defmodule Poker.CLI do
  alias Poker.{Result, CLI}

  use OK.Pipe

  @spec play(String.t()) :: String.t()
  def play(input) do
    input
    |> CLI.Formatter.input
    ~>> Result.compare
    ~>> CLI.Formatter.output
  end
end
