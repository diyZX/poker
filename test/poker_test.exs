defmodule PokerTest do
  use ExUnit.Case

  describe "incorrect input" do
    test "set of incorrect input" do
      assert {:error, :incorrect_input} =
        Poker.play("2C 3H 4S 8C AH, 2H 3D 5S 9C KD")
      assert {:error, :incorrect_input} =
        Poker.play("White: 2C 3H 4S 8C AH Black: 2H 3D 5S 9C KD")
    end
  end

  describe "examples" do
    test "examples" do
      assert "White wins - high card: Ace" =
        Poker.play("Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C AH")
      assert "White wins - flush" =
        Poker.play("Black: 2H 4S 4C 3D 4H White: 2S 8S AS QS 3S")
      assert "Black wins - high card: 9" =
        Poker.play("Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C KH")
      assert "Tie" =
        Poker.play("Black: 2H 3D 5S 9C KD White: 2D 3H 5C 9S KH")
    end
  end

  describe "full compare" do
    test "high card" do
      assert "Black wins - high card: 8" =
        Poker.play("Black: 2S 3C 4D 5S 8H White: 2H 3D 4S 5C 7D")
      assert "Tie" =
        Poker.play("Black: 2S 3C 4D 5S 7H White: 2C 3H 4S 5C 7D")
    end

    test "pair" do
      assert "White wins - pair" =
        Poker.play("Black: 2S 3C 4D 5S 7H White: 2H 3D 4S 6S 6H")
      assert "Black wins - pair: 6" =
        Poker.play("Black: 2H 3D 4S 6S 6H White: 2D 3C 4D 5H 5C")
      assert "Black wins - high card: 5" =
        Poker.play("Black: 2S 3C 5D 6S 6H White: 2C 3H 4H 6C 6D")
      assert "Tie" =
        Poker.play("Black: 2C 3D 4S 6S 6H White: 2S 3C 4D 6C 6D")
    end

    test "two pairs" do
      assert "White wins - two pairs" =
        Poker.play("Black: 2S 3C 4D 6S 6H White: 2D 2C 5D 5S 7H")
      assert "White wins - two pairs: 6" =
        Poker.play("Black: 2D 2C 5D 5S 7H White: 2S 2H 6C 6D 7D")
      assert "Black wins - two pairs: 3" =
        Poker.play("Black: 3D 3C 5D 5S 7H White: 2S 2H 5C 5H 7D")
      assert "Black wins - high card: 10" =
        Poker.play("Black: 2S 2H 5H 5C TH White: 2D 2C 5D 5S 7H")
      assert "Tie" =
        Poker.play("Black: 2H 2C 5D 5S 7H White: 2S 2D 5H 5C 7D")
    end

    test "three of a kind" do
      assert "Black wins - three of a kind" =
        Poker.play("Black: 2S 2C 2D 5S 7H White: 2H 2D 5D 5C 7C")
      assert "White wins - three of a kind: 3" =
        Poker.play("Black: 2S 2C 2D 5S 7H White: 3H 3D 3C 5C 7C")
    end

    test "straight" do
      assert "Black wins - straight" =
        Poker.play("Black: 2S 3C 4D 5S 6H White: 7C 7D 7H 6D 5S")
      assert "White wins - straight: 7" =
        Poker.play("Black: 2S 3C 4D 5S 6H White: 3D 4S 5H 6C 7D")
      assert "Tie" =
        Poker.play("Black: 2S 3C 4D 5S 6H White: 2D 3S 4H 5C 6D")
    end

    test "flush" do
      assert "White wins - flush" =
        Poker.play("Black: 2H 3C 4D 5C 6H White: 2S 8S 4S 5S AS")
      assert "Black wins - flush: Ace" =
        Poker.play("Black: 2S 8S 4S 5S AS White: 2C 8C 4C 5C QC")
      assert "Tie" =
        Poker.play("Black: 2S 8S 4S 5S AS White: 2C 8C 4C 5C AC")
    end

    test "full house" do
      assert "Black wins - full house" =
        Poker.play("Black: 2H 2C 2D 7S 7H White: 2S 8S 4S 5S AS")
      assert "White wins - full house: 3" =
        Poker.play("Black: 2H 2C 2D 7S 7H White: 3S 3H 3C 5S 5D")
    end

    test "four of a kind" do
      assert "Black wins - four of a kind" =
        Poker.play("Black: 2S 2C 2D 2H 7H White: 3S 3C 3D 8S 8C")
      assert "White wins - four of a kind: 3" =
        Poker.play("Black: 2S 2C 2D 2H 7H White: 3C 3D 3S 3H 5D")
    end

    test "straight flush" do
      assert "White wins - straight flush" =
        Poker.play("Black: 7H 7S 7D 7C 8S White: 2S 3S 4S 5S 6S")
      assert "Black wins - straight flush: 7" =
        Poker.play("Black: 3H 4H 5H 6H 7H White: 2S 3S 4S 5S 6S")
    end
  end
end
