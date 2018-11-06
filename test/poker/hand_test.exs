defmodule Poker.HandTest do
  use ExUnit.Case, async: true
  use OK.Pipe

  alias Poker.{Hand}

  describe "incorrect input" do
    test "incorrect card" do
      assert {:error, :incorrect_card} = Hand.new("2E 3C 4D 5S 6H")
    end

    test "incorrect number of cards" do
      assert {:error, :incorrect_number_of_cards} = Hand.new("2S 3C 4D 5S")
    end

    test "not unique cards" do
      assert {:error, :not_unique_cards} = Hand.new("2S 3C 4D 5S 2S")
    end
  end

  describe "correct input" do
    test "set of correct input" do
      assert {:ok, %Hand{cards: _}} = Hand.new("2S 3C 4D 5S 6H")
      assert {:ok, %Hand{cards: _}} = Hand.new("  2S  3C  4D  5S  6H ")
    end
  end

  describe "auxiliary functions" do
    test "sort" do
      sorted_hand = "2S 3C 4D 5S 6H" |> Hand.new ~>> Hand.sort
      assert %{cards: [%{value: "6"}, _, _, _, %{value: "2"}]} = sorted_hand
    end

    test "same suit" do
      assert false == ("2S 3C 4D 5S 6H" |> Hand.new ~>> Hand.same_suit?)
      assert true  == ("2S 3S 4S 5S 6S" |> Hand.new ~>> Hand.same_suit?)
    end

    test "consecutive" do
      assert true  == ("2S 3C 4D 5S 6H" |> Hand.new ~>> Hand.consecutive?)
      assert true  == ("QS TC JD 8S 9H" |> Hand.new ~>> Hand.consecutive?)
      assert false == ("2S 3C 5D 5S 6H" |> Hand.new ~>> Hand.consecutive?)
    end

    test "kinds" do
      assert [{1, _}, {1, _}, {1, _}, {1, _}, {1, _}] = "2S 3C 4D 5S 6H" |> kinds
      assert [{2, _}, {1, _}, {1, _}, {1, _}]         = "2S 2C 4D 5S 6H" |> kinds
      assert [{2, _}, {2, _}, {1, _}]                 = "2S 2C 5D 5S 6H" |> kinds
      assert [{3, _}, {1, _}, {1, _}]                 = "2S 2C 4D 5S 2H" |> kinds
      assert [{3, _}, {2, _}]                         = "2S 2C 5D 5S 2H" |> kinds
      assert [{4, _}, {1, _}]                         = "2S 2C 5D 2D 2H" |> kinds
    end

    defp kinds(input), do: input |> Hand.new ~>> Hand.kinds
  end
end
