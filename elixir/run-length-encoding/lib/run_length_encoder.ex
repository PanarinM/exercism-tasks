defmodule RunLengthEncoder do
  @numbers [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "0",
]

  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    string
    |> group
    |> Enum.map(fn {letter, amount} ->
      if amount == 1 do
        "#{letter}"
      else
        "#{amount}#{letter}"
      end
    end)
    |> Enum.join
  end

  @spec decode(String.t()) :: String.t()
  def decode(string) do
    string
    |> ungroup
    |> Enum.map(fn {letter, amount} ->
      String.duplicate(letter, amount)
    end)
    |> Enum.join
  end

  defp group(string) do
    string
    |> String.graphemes
    |> Enum.reduce([], fn letter, acc ->
      case acc do
        [] -> [{letter, 1} | acc]
        [{prev, amount} | tail] ->
          if letter == prev do
            [{letter, amount + 1} | tail]
          else
            [{letter, 1} | acc]
          end
      end
    end)
    |> Enum.reverse
  end

  defp ungroup(string) do
    string
    |> String.graphemes
    |> Enum.reduce([[], []], fn item, [hanging, data] ->
      if item in @numbers do
        [[item | hanging], data]
      else
        number = cond do
          hanging != [] -> hanging
            |> Enum.reverse
            |> Enum.join
            |> String.to_integer
          true -> 1
          end
        [[], [{item, number} | data]]
      end
    end)
    |> Enum.at(-1)
    |> Enum.reverse
  end
end
