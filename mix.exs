defmodule Poker.MixProject do
  use Mix.Project

  def project do
    [
      app: :poker,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:ok, "~> 2.0"},
    ]
  end
end
