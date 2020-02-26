defmodule Say do
  @digits %{
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    6 => "six",
    7 => "seven",
    8 => "eight",
    9 => "nine",
    10 => "ten",
    11 => "eleven",
    12 => "twelve",
    13 => "thirteen",
    14 => "fourteen",
    15 => "fifteen",
    16 => "sixteen",
    17 => "seventeen",
    18 => "eighteen",
    19 => "nineteen",
    20 => "twenty",
    30 => "thirty",
    40 => "forty",
    50 => "fifty",
    60 => "sixty",
    70 => "seventy",
    80 => "eighty",
    90 => "ninety",
  }
  @other [
    "hundred",
    "thousand",
    "million",
    "billion",
    "trillion",
  ]

  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(number) when number < 0, do: {:error, "number is out of range"}
  def in_english(number) when number > 999999999999, do: {:error, "number is out of range"}
  def in_english(0), do: {:ok, "zero"}
  def in_english(number) do
    result = to_string(number)
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> convert_to_english

    {:ok, result}
  end

  def convert_to_english(number) do
    {high_order, tenth} = number
    |> Enum.split(-2)

    Enum.join([convert_high_order(high_order), convert_tenth(tenth)], " ")
    |> String.trim
  end

  defp convert_tenth([0, 0]), do: ""
  defp convert_tenth([x]), do: @digits[x]
  defp convert_tenth([x, y]) do
    number = x * 10 + y
    if number in Map.keys(@digits) do
      @digits[number]
    else
      @digits[x * 10] <> "-" <> @digits[y]
    end
  end

  defp convert_high_order([]), do: ""
  defp convert_high_order([[], [a]]), do: @digits[a] <> " " <> "hundred"
  defp convert_high_order(other) do
    other
    |> prepare_list
    |> Enum.reverse
    |> Enum.zip(@other)
    |> Enum.reduce([], fn {number, str}, acc ->
      cond do
        Enum.all?(number, fn x -> x == 0 end) -> acc
        true -> acc ++ [convert_to_english(number) <> " " <> str]
      end
    end)
    |> Enum.reverse
    |> Enum.join(" ")
  end

  def prepare_list(list) do
    {other, hundreds} = Enum.split(list, -1)
    other
    |> Enum.reverse
    |> Enum.chunk_every(3)
    |> Enum.map(&Enum.reverse/1)
    |> Enum.reverse
    |> Kernel.++([hundreds])
  end
end
