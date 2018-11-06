defmodule Poker.Result do
  alias __MODULE__
  alias Poker.{Card, Hand, Rank}

  use OK.Pipe

  @enforce_keys [:black, :white, :winner]
  @type t() :: %Result{
    black: Rank.t(),
    white: Rank.t(),
    winner: atom(),
    variant: atom(),
    highest_card: Card.t()
  }

  defstruct [
    :black,
    :white,
    :winner,
    :variant,
    :highest_card
  ]

  ## Creational functions

  @spec compare({String.t(), String.t()}) :: {:ok, t()} | {:error, atom()}
  def compare({black, white}), do: compare(black, white)
  def compare(black, white) when is_binary(black) and is_binary(white),
    do: compare(black |> rank, white |> rank)
  def compare(%Rank{} = black_rank, %Rank{} = white_rank),
    do: compare_variants(%Result{black: black_rank, white: white_rank, winner: :tie})
  def compare({:error, _} = black, _), do: black
  def compare(_, {:error, _} = white), do: white

  ## Private functions

  defp compare_variants(%Result{black: black_rank, white: white_rank} = result) do
    case Rank.compare(black_rank, white_rank) do
      :gt ->
        {:ok, %{result | winner: :black, variant: black_rank.variant}}
      :lt ->
        {:ok, %{result | winner: :white, variant: white_rank.variant}}
      :eq ->
        compare_tie(result, :highest_cards, black_rank.variant)
    end
  end

  defp compare_tie(%Result{} = result, cards_atom, variant) do
    case compare_cards(Map.get(result.black, cards_atom),
          Map.get(result.white, cards_atom)) do
      {winner, card} ->
        {:ok, %{result | winner: winner, variant: variant, highest_card: card}}
      :tie ->
        cond do
          variant in [:high_card, :straight, :flush] ->
            {:ok, %{result | winner: :tie}}
          true ->
            compare_tie(result, :remaining_cards, :high_card)
        end
    end
  end

  defp compare_cards(black_cards, white_cards) do
    0..(length(black_cards) - 1)
    |> Enum.map(&(
          case Card.compare(Enum.at(black_cards, &1), Enum.at(white_cards, &1)) do
            :gt -> {:black, black_cards |> Enum.at(&1)}
            :lt -> {:white, white_cards |> Enum.at(&1)}
            :eq -> :tie
          end))
    |> Enum.reduce_while(:tie, &(if &1 == :tie, do: {:cont, &2}, else: {:halt, &1}))
  end

  defp rank(cards), do: cards |> Hand.new ~>> Rank.define |> result

  defp result({:ok, value}),        do: value
  defp result({:error, _} = error), do: error
end
