defmodule Poker.Hand do
  alias __MODULE__
  alias Poker.{Card}

  use OK.Pipe

  @enforce_keys [:cards]
  @type t() :: %Hand{
    cards: [Card.t()]
  }

  defstruct [
    :cards
  ]

  @cards_number 5

  ## Creational functions

  @spec new(String.t()) :: {:ok, t()} | {:error, atom()}
  def new(cards) when is_binary(cards) do
    cards
    |> String.split(~r{\s}, trim: true)
    |> Enum.map(&Card.new/1)
    |> Enum.reduce_while({:ok, []}, &reduce_card/2)
    ~>> count_cards
    ~>> uniq_cards
  end

  ## Auxiliary functions

  @spec sort(t()) :: t()
  def sort(%Hand{} = hand) do
    sorted_cards =
      hand.cards
      |> Enum.sort_by(&(Card.value_rank(&1.value)), &>=/2)

    %{hand | cards: sorted_cards}
  end

  @spec same_suit?(t()) :: boolean()
  def same_suit?(%Hand{} = hand) do
    all_suits = hand.cards
    |> Enum.map(&(&1.suit))
    |> Enum.uniq

    1 == length(all_suits)
  end

  @spec consecutive?(t()) :: boolean()
  def consecutive?(%Hand{} = hand) do
    (hand |> sort).cards
    |> Enum.map(&Card.value_rank/1)
    |> cons?
  end

  @spec kinds(t()) :: [{integer(), [Card.t()]}]
  def kinds(%Hand{} = hand) do
    hand.cards
    |> Enum.reduce(%{}, &(Map.put(&2, &1.value, [&1 | Map.get(&2, &1.value, [])])))
    |> Map.to_list
    |> Enum.map(fn {_, cards} -> {length(cards), cards} end)
    |> Enum.sort_by(fn {len, cards} -> len * 10 + (Card.value_rank(cards |> hd)) end, &>=/2)
  end

  ## Private functions

  defp reduce_card(card, {:ok, cards}) do
    case card do
      {:ok, card}     -> {:cont, {:ok, [card | cards]}}
      {:error, error} -> {:halt, {:error, error}}
    end
  end

  defp count_cards(cards) when is_list(cards) and length(cards) == @cards_number,
    do: {:ok, cards}
  defp count_cards(cards) when is_list(cards),
    do: {:error, :incorrect_number_of_cards}

  defp uniq_cards(cards) when is_list(cards) do
    case length(cards |> Enum.uniq) == @cards_number do
      true  -> {:ok, %Hand{cards: cards}}
      false -> {:error, :not_unique_cards}
    end
  end

  defp cons?([r1 | [r2 | _] = rest]),
    do: (r1 == r2 + 1) && cons?(rest)
  defp cons?([_]),
    do: true
end
