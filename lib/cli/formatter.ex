defmodule Poker.CLI.Formatter do
  alias Poker.{Card, Result}

  @input_format ~r/Black: (?<black>[\s\w]+) White: (?<white>[\s\w]+)/

  @spec input(String.t()) :: {:ok, [String.t()]} | {:error, atom()}
  def input(input) do
    case Regex.named_captures(@input_format, input) do
      %{"black" => black_cards, "white" => white_cards} ->
        {:ok, {black_cards, white_cards}}
      nil ->
        {:error, :incorrect_input}
    end
  end

  @spec output(Result.t()) :: String.t()
  def output(%Result{} = result),
    do: "#{winner(result)}#{variant(result)}#{highest_card(result)}"

  ## Private functions

  defp winner(%Result{winner: :black}), do: "Black wins"
  defp winner(%Result{winner: :white}), do: "White wins"
  defp winner(%Result{winner: :tie}),   do: "Tie"

  defp variant(%Result{variant: nil}),     do: ""
  defp variant(%Result{variant: variant}), do: " - #{atom_to_str(variant)}"

  defp highest_card(%Result{highest_card: nil}),  do: ""
  defp highest_card(%Result{highest_card: card}), do: ": #{card_value(card)}"

  defp card_value(%Card{value: value}) do
    cond do
      value in (2..9 |> Enum.map(&("#{&1}"))) -> value
      value == "T" -> "10"
      value == "J" -> "Jack"
      value == "Q" -> "Queen"
      value == "K" -> "King"
      value == "A" -> "Ace"
    end
  end

  defp atom_to_str(atom), do: String.replace("#{atom}", "_", " ")
end
