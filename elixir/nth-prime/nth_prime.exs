defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  def nth(0), do: raise Error

  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) do
    exclude = Enum.reduce(1..count * 3, [], fn x, acc ->
      acc ++ Enum.map(x..count * 3, fn y -> x + y + 2 * x * y end)
    end)
    range = for n <- 1..count * 3, n not in exclude, do: n * 2 + 1
    range = [1, 2] ++ range
    Enum.fetch!(range, count)
  end
end
