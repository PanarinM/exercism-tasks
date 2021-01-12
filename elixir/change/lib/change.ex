defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(coins, target) do
    case generate(Enum.reverse(coins), target, []) do
      {:error, _} -> {:error, "cannot change"}
      {:ok, result} -> {:ok, result}
    end
  end

  @spec generate(list, integer, list) :: {:ok, list} | {:error, String.t()}
  defp generate([], 0, result), do: {:ok, result}
  defp generate([], target, _result), do: {:error, "#{target} left"}
  defp generate(coins, target, result) do
    [coin | coins] = coins
    target_left = rem(target, coin)
    coin_amount = div(target, coin)

    coin_list = case coin_amount do
      0 -> []
      _ -> for _ <- 1..coin_amount, do: coin
    end

    generate(coins, target_left, coin_list ++ result)
  end
end
