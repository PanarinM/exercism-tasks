defmodule StringSeries do
  @doc """
  Given a string `s` and a positive integer `size`, return all substrings
  of that size. If `size` is greater than the length of `s`, or less than 1,
  return an empty list.
  """
  @spec slices(s :: String.t(), size :: integer) :: list(String.t())
  def slices(s, size) do
    s = String.graphemes(s)
    cond do
      size < 1 or size > length(s) -> []
      true -> Enum.chunk_every(s, size, 1, :discard)
      |>Enum.reduce([], fn x, acc ->
        [Enum.join(x) | acc]
      end)
      |> Enum.reverse
    end
  end
end
