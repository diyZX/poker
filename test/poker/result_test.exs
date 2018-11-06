defmodule Poker.ResultTest do
  use ExUnit.Case, async: true

  alias Poker.{Result}

  describe "full compare" do
    test "high card" do
      assert {:ok, %{winner: :black, variant: :high_card, highest_card: %{value: "8"}}} =
        Result.compare("2S 3C 4D 5S 8H", "2H 3D 4S 5C 7D")
      assert {:ok, %{winner: :tie, variant: nil, highest_card: nil}} =
        Result.compare("2S 3C 4D 5S 7H", "2C 3H 4S 5C 7D")
    end

    test "pair" do
      assert {:ok, %{winner: :white, variant: :pair, highest_card: nil}} =
        Result.compare("2S 3C 4D 5S 7H", "2H 3D 4S 6S 6H")
      assert {:ok, %{winner: :black, variant: :pair, highest_card: %{value: "6"}}} =
        Result.compare("2H 3D 4S 6S 6H", "2D 3C 4D 5H 5C")
      assert {:ok, %{winner: :black, variant: :high_card, highest_card: %{value: "5"}}} =
        Result.compare("2S 3C 5D 6S 6H", "2C 3H 4H 6C 6D")
      assert {:ok, %{winner: :tie, variant: nil, highest_card: nil}} =
        Result.compare("2C 3D 4S 6S 6H", "2S 3C 4D 6C 6D")
    end

    test "two pairs" do
      assert {:ok, %{winner: :white, variant: :two_pairs, highest_card: nil}} =
        Result.compare("2S 3C 4D 6S 6H", "2D 2C 5D 5S 7H")
      assert {:ok, %{winner: :white, variant: :two_pairs, highest_card: %{value: "6"}}} =
        Result.compare("2D 2C 5D 5S 7H", "2S 2H 6C 6D 7D")
      assert {:ok, %{winner: :black, variant: :two_pairs, highest_card: %{value: "3"}}} =
        Result.compare("3D 3C 5D 5S 7H", "2S 2H 5C 5H 7D")
      assert {:ok, %{winner: :black, variant: :high_card, highest_card: %{value: "T"}}} =
        Result.compare("2S 2H 5H 5C TH", "2D 2C 5D 5S 7H")
      assert {:ok, %{winner: :tie, variant: nil, highest_card: nil}} =
        Result.compare("2H 2C 5D 5S 7H", "2S 2D 5H 5C 7D")
    end

    test "three of a kind" do
      assert {:ok, %{winner: :black, variant: :three_of_a_kind, highest_card: nil}} =
        Result.compare("2S 2C 2D 5S 7H", "2H 2D 5D 5C 7C")
      assert {:ok, %{winner: :white, variant: :three_of_a_kind, highest_card: %{value: "3"}}} =
        Result.compare("2S 2C 2D 5S 7H", "3H 3D 3C 5C 7C")
    end

    test "straight" do
      assert {:ok, %{winner: :black, variant: :straight, highest_card: nil}} =
        Result.compare("2S 3C 4D 5S 6H", "7C 7D 7H 6D 5S")
      assert {:ok, %{winner: :white, variant: :straight, highest_card: %{value: "7"}}} =
        Result.compare("2S 3C 4D 5S 6H", "3D 4S 5H 6C 7D")
      assert {:ok, %{winner: :tie, variant: nil, highest_card: nil}} =
        Result.compare("2S 3C 4D 5S 6H", "2D 3S 4H 5C 6D")
    end

    test "flush" do
      assert {:ok, %{winner: :white, variant: :flush, highest_card: nil}} =
        Result.compare("2H 3C 4D 5C 6H", "2S 8S 4S 5S AS")
      assert {:ok, %{winner: :black, variant: :flush, highest_card: %{value: "A"}}} =
        Result.compare("2S 8S 4S 5S AS", "2C 8C 4C 5C QC")
      assert {:ok, %{winner: :tie, variant: nil, highest_card: nil}} =
        Result.compare("2S 8S 4S 5S AS", "2C 8C 4C 5C AC")
    end

    test "full house" do
      assert {:ok, %{winner: :black, variant: :full_house, highest_card: nil}} =
        Result.compare("2H 2C 2D 7S 7H", "2S 8S 4S 5S AS")
      assert {:ok, %{winner: :white, variant: :full_house, highest_card: %{value: "3"}}} =
        Result.compare("2H 2C 2D 7S 7H", "3S 3H 3C 5S 5D")
    end

    test "four of a kind" do
      assert {:ok, %{winner: :black, variant: :four_of_a_kind, highest_card: nil}} =
        Result.compare("2S 2C 2D 2H 7H", "3S 3C 3D 8S 8C")
      assert {:ok, %{winner: :white, variant: :four_of_a_kind, highest_card: %{value: "3"}}} =
        Result.compare("2S 2C 2D 2H 7H", "3C 3D 3S 3H 5D")
    end

    test "straight flush" do
      assert {:ok, %{winner: :white, variant: :straight_flush, highest_card: nil}} =
        Result.compare("7H 7S 7D 7C 8S", "2S 3S 4S 5S 6S")
      assert {:ok, %{winner: :black, variant: :straight_flush, highest_card: %{value: "7"}}} =
        Result.compare("3H 4H 5H 6H 7H", "2S 3S 4S 5S 6S")
    end
  end
end
