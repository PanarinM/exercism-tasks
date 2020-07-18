defmodule AllYourBase do
  @doc """
  Given a number in base a, represented as a sequence of digits, converts it to base b,
  or returns nil if either of the bases are less than 2
  """

  @spec convert([integer], integer, integer) :: [integer] | nil
  def convert(_, base_a, base_b) when base_a < 2 or base_b < 2, do: nil
  def convert([], _, _), do: nil

  def convert(digits, base_a, base_b) do
    digits
    |> convert_to_10(base_a)
    |> case  do
         {:error, _} -> nil
         {:ok, vals} -> convert_from_10(vals, base_b)
       end
  end

  defp convert_to_10(digits, base) do
    len = length(digits)
    digits = digits
    |> Enum.with_index(1)
    |> Enum.map(fn
      {e, _} when e >= base or e < 0 -> nil
      {e, index} -> e * :math.pow(base, (len - index)) |> trunc
    end)
    if nil in digits do
      {:error, "Invalid digits"}
    else
      {:ok, Enum.sum(digits)}
    end
  end

  defp convert_from_10([0 | i], _), do: i
  defp convert_from_10([i | tail], base) when i < base, do: [i | tail]
  defp convert_from_10([i | tail], base), do: convert_from_10(i, base) ++ tail
  defp convert_from_10(i, base), do: convert_from_10([div(i, base), rem(i, base)], base)
end
