defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @luhn_regex ~r/^[0-9 ]+$/
  @normalize_regex ~r/[0-9]+/

  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    with {:ok, value} <- normalize(number) do
      value
      |> String.graphemes()
      |> Enum.map(&String.to_integer(&1))
      |> check_numbers()
    else
      {:error, _} -> false
    end
  end

  @spec normalize(String.t()) :: {:ok | :error, String.t()}
  defp normalize(number) do
    unless Regex.match?(@luhn_regex, number) do
      {:error, "wrong number"}
    else
      normalized_value =
        @normalize_regex
        |> Regex.scan(number)
        |> List.flatten()
        |> Enum.join()

      {:ok, normalized_value}
    end
  end

  defp check_numbers(numbers) when length(numbers) <= 1, do: false

  defp check_numbers(numbers) do
    numbers
    |> Enum.reverse()
    |> map_nth_starting_from_nth(1, 2, fn x ->
      x
      |> Kernel.*(2)
      |> maybe_subtract_nine()
    end)
    |> Enum.sum()
    |> rem(10)
    |> Kernel.==(0)
  end

  defp maybe_subtract_nine(number) when number > 9, do: number - 9
  defp maybe_subtract_nine(number), do: number

  @spec map_nth_starting_from_nth(Enum.t(), integer(), non_neg_integer(), fun()) :: Enum.t()
  defp map_nth_starting_from_nth(enum, from, nth, fun) do
    Kernel.++(
      Enum.take(enum, from),
      enum
      |> Stream.drop(from)
      |> Stream.map_every(nth, fun)
      |> Enum.to_list()
    )
  end
end
