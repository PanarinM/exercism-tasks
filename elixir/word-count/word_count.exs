defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.downcase
    |> String.split(~r/[[:punct:]]\B| /, trim: true)
    |> Enum.reduce(%{}, fn x, acc ->
      Map.update(acc, x, 1, fn x ->
        x + 1
      end)
    end)
  end
end
