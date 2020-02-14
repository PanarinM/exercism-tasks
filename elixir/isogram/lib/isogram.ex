defmodule Isogram do
  @ignored [" ", "-"]
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    sentence
    |> String.graphemes
    |> Enum.reduce_while([], fn x, acc ->
      cond do
        x in @ignored -> {:cont, acc}
        x in acc -> {:halt, false}
        true -> {:cont, [x | acc]}
      end
    end)
    |> Kernel.!
    |> Kernel.!
  end
end
