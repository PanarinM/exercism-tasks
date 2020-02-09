defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    Enum.reduce(0..limit-1, 0, fn x, acc ->
      Enum.reduce_while(factors, 0, fn y, zero ->
        case rem(x, y) do
          0 -> {:halt, x}
          _ -> {:cont, zero}
        end
      end)
      |> Kernel.+(acc)
    end)
  end
end
