defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare([], []), do: :equal
  def compare([], _), do: :sublist
  def compare(_, []), do: :superlist
  def compare(a, b) do
    cond do
      a == b -> :equal
      contains?(a, b) -> :sublist
      contains?(b, a) -> :superlist
      true -> :unequal
    end
  end

  @doc """
  Checks whether list `b` contains list `a`
  """
  @spec contains?(list, list) :: boolean
  def contains?(a, b) do
    Enum.reduce_while(0..(length(b) - length(a)), false, fn index, _ ->
      Enum.slice(b, index..-1)
      |> List.starts_with?(a)
      |> if do
        {:halt, true}
      else
        {:cont, false}
      end
    end)
  end
end
