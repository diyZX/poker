defmodule Poker.Card do
  alias __MODULE__

  @enforce_keys [:value, :suit]
  @type t() :: %Card{
    value: String.t(),
    suit: String.t()
  }

  defstruct [
    :value,
    :suit
  ]

  @values ~w(2 3 4 5 6 7 8 9 T J Q K A)
  @suits  ~w(C D H S)

  ## Creational functions

  @spec new(String.t()) :: {:ok, t()} | {:error, atom()}
  def new(card) when is_binary(card) and byte_size(card) == 2 do
    with [value, suit] <- String.graphemes(card),
      do: create(%{value: value |> String.upcase, suit: suit |> String.upcase})
  end
  def new(_), do: {:error, :incorrect_card}

  ## Auxiliary functions

  @spec values() :: [String.t()]
  def values(), do: @values

  @spec suits() :: [String.t()]
  def suits, do: @suits

  @spec value_rank(t() | String.t()) :: integer | :error
  def value_rank(%Card{} = card),
    do: value_rank(card.value)
  def value_rank(value) when value in @values,
    do: 2 + Enum.find_index(values(), &(&1 == (value |> String.upcase)))
  def value_rank(_),
    do: :error

  @spec compare(t(), t()) :: :lt | :eq | :gt
  def compare(%Card{} = left_card, %Card{} = right_card) do
    cond do
      value_rank(left_card) < value_rank(right_card)  -> :lt
      value_rank(left_card) > value_rank(right_card)  -> :gt
      value_rank(left_card) == value_rank(right_card) -> :eq
    end
  end

  ## Private functions

  defp create(%{value: value, suit: suit}) when value in @values and suit in @suits,
    do: {:ok, %Card{value: value, suit: suit}}
  defp create(_),
    do: {:error, :incorrect_card}
end

