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
  def contains?(_, []),  do: false
  def contains?(a, b) do
    List.starts_with?(b, a) || contains?(a, tl(b))
  end
end
