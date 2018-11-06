defmodule Poker.RankTest do
  use ExUnit.Case, async: true
  use OK.Pipe

  alias Poker.{Hand, Rank}

  describe "variants" do
    test "define variant" do
      assert {:ok, %{variant: :high_card}}       = "2S 3C 4D 5S 7H" |> rank
      assert {:ok, %{variant: :pair}}            = "2S 3C 4D 6S 6H" |> rank
      assert {:ok, %{variant: :two_pairs}}       = "2S 2C 5D 5S 7H" |> rank
      assert {:ok, %{variant: :three_of_a_kind}} = "2S 2C 2D 5S 7H" |> rank
      assert {:ok, %{variant: :straight}}        = "2S 3C 4D 5S 6H" |> rank
      assert {:ok, %{variant: :flush}}           = "2S 8S 4S 5S AS" |> rank
      assert {:ok, %{variant: :full_house}}      = "2S 2C 2D 7S 7H" |> rank
      assert {:ok, %{variant: :four_of_a_kind}}  = "2S 2C 2D 2H 7H" |> rank
      assert {:ok, %{variant: :straight_flush}}  = "2S 3S 4S 5S 6S" |> rank
    end

    test "variant rank" do
      assert Rank.variant_rank(:high_card) < Rank.variant_rank(:pair)
      assert Rank.variant_rank(:pair) < Rank.variant_rank(:two_pairs)
      assert Rank.variant_rank(:two_pairs) < Rank.variant_rank(:three_of_a_kind)
      assert Rank.variant_rank(:three_of_a_kind) < Rank.variant_rank(:straight)
      assert Rank.variant_rank(:straight) < Rank.variant_rank(:flush)
      assert Rank.variant_rank(:flush) < Rank.variant_rank(:full_house)
      assert Rank.variant_rank(:full_house) < Rank.variant_rank(:four_of_a_kind)
      assert Rank.variant_rank(:four_of_a_kind) < Rank.variant_rank(:straight_flush)
      assert :error = Rank.variant_rank(:test)
    end

    defp rank(input), do: input |> Hand.new ~>> Rank.define
  end
end
