defmodule Poker.CardTest do
  use ExUnit.Case, async: true

  alias Poker.{Card}

  describe "incorrect input" do
    test "set of incorrect input" do
      assert {:error, :incorrect_card} = Card.new(nil)
      assert {:error, :incorrect_card} = Card.new("")
      assert {:error, :incorrect_card} = Card.new("test")
      assert {:error, :incorrect_card} = Card.new('2C')
      assert {:error, :incorrect_card} = Card.new(10)
      assert {:error, :incorrect_card} = Card.new(["2C"])
      assert {:error, :incorrect_card} = Card.new(["2", "C"])
      assert {:error, :incorrect_card} = Card.new("10D")
      assert {:error, :incorrect_card} = Card.new("2E")
      assert {:error, :incorrect_card} = Card.new(" 2C ")
      assert {:error, :incorrect_card} = Card.new("2C 2D")
      assert {:error, :incorrect_card} = Card.new("AceD")
      assert {:error, :incorrect_card} = Card.new("2 C")
      assert {:error, :incorrect_card} = Card.new("C2")
      assert {:error, :incorrect_card} = Card.new("2♥")
    end
  end

  describe "correct input" do
    test "set of correct input" do
      assert {:ok, %Card{value: "2", suit: "C"}} = Card.new("2C")
      assert {:ok, %Card{value: "9", suit: "D"}} = Card.new("9D")
      assert {:ok, %Card{value: "T", suit: "H"}} = Card.new("TH")
      assert {:ok, %Card{value: "A", suit: "S"}} = Card.new("AS")
    end

    test "set of correct lowercase input" do
      assert {:ok, %Card{value: "2", suit: "C"}} = Card.new("2c")
      assert {:ok, %Card{value: "9", suit: "D"}} = Card.new("9d")
      assert {:ok, %Card{value: "T", suit: "H"}} = Card.new("th")
      assert {:ok, %Card{value: "A", suit: "S"}} = Card.new("as")
    end

    test "all correct values and suits" do
      for v <- Card.values() do
        for s <- Card.suits() do
          assert {:ok, %Card{}} = Card.new("#{v}#{s}")
        end
      end
    end
  end

  describe "comparation" do
    setup do
      cards = ["2C", "5D", "5C", "9H", "TS", "JC", "QD", "QC", "KH", "AS"]
      |> Enum.reduce(%{}, fn c, acc ->
        with {:ok, card} <- Card.new(c), do: Map.put(acc, c, card)
      end)

      {:ok, %{cards: cards}}
    end

    test "lt", %{cards: cards} do
      assert :lt = Card.compare(cards["2C"], cards["5D"])
      assert :lt = Card.compare(cards["5D"], cards["9H"])
      assert :lt = Card.compare(cards["9H"], cards["TS"])
      assert :lt = Card.compare(cards["TS"], cards["JC"])
      assert :lt = Card.compare(cards["JC"], cards["QD"])
      assert :lt = Card.compare(cards["QD"], cards["KH"])
      assert :lt = Card.compare(cards["KH"], cards["AS"])
    end

    test "gt", %{cards: cards} do
      assert :gt = Card.compare(cards["5D"], cards["2C"])
      assert :gt = Card.compare(cards["9H"], cards["5D"])
      assert :gt = Card.compare(cards["TS"], cards["9H"])
      assert :gt = Card.compare(cards["JC"], cards["TS"])
      assert :gt = Card.compare(cards["QD"], cards["JC"])
      assert :gt = Card.compare(cards["KH"], cards["QD"])
      assert :gt = Card.compare(cards["AS"], cards["KH"])
    end

    test "eq", %{cards: cards} do
      assert :eq = Card.compare(cards["5D"], cards["5C"])
      assert :eq = Card.compare(cards["QD"], cards["QC"])
    end
  end
end
