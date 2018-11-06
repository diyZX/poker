defmodule Poker.Rank do
  alias __MODULE__
  alias Poker.{Card, Hand}

  @enforce_keys [:hand]
  @type t() :: %Rank{
    hand: Hand.t(),
    variant: atom(),
    highest_cards: [Card.t()],
    remaining_cards: [Card.t()]
  }

  defstruct [
    :hand,
    :variant,
    :highest_cards,
    :remaining_cards
  ]

  @variants ~w(high_card pair two_pairs three_of_a_kind straight
    flush full_house four_of_a_kind straight_flush)a

  ## Creational functions

  @spec define(Hand.t()) :: {:ok, t()} | {:error, atom()}
  def define(%Hand{} = hand) do
    rank = %Rank{hand: hand}
    kinds = Hand.kinds(hand)
    same_suit? = Hand.same_suit?(hand)
    consecutive? = Hand.consecutive?(hand)

    define_variant(rank, {kinds, same_suit?, consecutive?})
  end

  ## Auxiliary functions

  @spec variants() :: [atom()]
  def variants(), do: @variants

  @spec variant_rank(t() | atom()) :: integer | :error
  def variant_rank(%Rank{} = rank),
    do: variant_rank(rank.variant)
  def variant_rank(variant) when variant in @variants,
    do: 1 + Enum.find_index(variants(), &(&1 == variant))
  def variant_rank(_),
    do: :error

  @spec compare(t(), t()) :: :lt | :eq | :gt
  def compare(%Rank{} = black_rank, %Rank{} = whire_rank) do
    cond do
      variant_rank(black_rank) < variant_rank(whire_rank)  -> :lt
      variant_rank(black_rank) > variant_rank(whire_rank)  -> :gt
      variant_rank(black_rank) == variant_rank(whire_rank) -> :eq
    end
  end
  def compare({:error, _} = black, _), do: black
  def compare(_, {:error, _} = white), do: white

  ## Private functions

  defp define_variant(rank, {[{1, [c]} | _], true, true}),
    do: {:ok, %{rank | variant: :straight_flush,
      highest_cards: [c], remaining_cards: []}}
  defp define_variant(rank, {[{4, [c1 | _]}, {1, [c2]}], false, false}),
    do: {:ok, %{rank | variant: :four_of_a_kind,
      highest_cards: [c1], remaining_cards: [c2]}}
  defp define_variant(rank, {[{3, [c1 | _]}, {2, [c2 | _]}], false, false}),
    do: {:ok, %{rank | variant: :full_house,
      highest_cards: [c1, c2], remaining_cards: []}}
  defp define_variant(rank, {_, true, false}),
    do: {:ok, %{rank | variant: :flush,
      highest_cards: Hand.sort(rank.hand).cards, remaining_cards: []}}
  defp define_variant(rank, {_, false, true}),
    do: {:ok, %{rank | variant: :straight,
      highest_cards: Hand.sort(rank.hand).cards, remaining_cards: []}}
  defp define_variant(rank, {[{3, [c1 | _]}, {1, [c2]}, {1, [c3]}], _, _}),
    do: {:ok, %{rank | variant: :three_of_a_kind,
      highest_cards: [c1], remaining_cards: [c2, c3]}}
  defp define_variant(rank, {[{2, [c1 | _]}, {2, [c2 | _]}, {1, [c3]}], _, _}),
    do: {:ok, %{rank | variant: :two_pairs,
      highest_cards: [c1, c2], remaining_cards: [c3]}}
  defp define_variant(rank, {[{2, [c1 | _]}, {1, [c2]}, {1, [c3]}, {1, [c4]}], _, _}),
    do: {:ok, %{rank | variant: :pair,
      highest_cards: [c1], remaining_cards: [c2, c3, c4]}}
  defp define_variant(rank, {[{1, _}, {1, _}, {1, _}, {1, _}, {1, _}], _, _}),
    do: {:ok, %{rank | variant: :high_card,
      highest_cards: Hand.sort(rank.hand).cards, remaining_cards: []}}
end
