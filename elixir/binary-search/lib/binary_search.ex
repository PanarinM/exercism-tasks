defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search({}, _) do
    :not_found
  end
  def search(numbers, key) do
    search(numbers, key, 0, tuple_size(numbers) - 1)
  end

  defp search(tuple, key, start_, end_) when start_ == end_ do
    if elem(tuple, start_) == key do
      {:ok, start_}
    else
      :not_found
    end
  end
  defp search(_, _, _, end_) when end_ < 0, do: :not_found
  defp search(tuple, key, start_, end_) do
    index = ((end_ - start_) |> div(2)) + start_
    point = elem(tuple, index)
    cond do
      point == key -> {:ok, index}
      point > key -> search(tuple, key, start_, index - 1)
      point < key -> search(tuple, key, index + 1, end_)
    end
  end
end
