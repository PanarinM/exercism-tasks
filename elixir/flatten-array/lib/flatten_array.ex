defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list) do
    list
    |> Enum.reduce([], fn x, acc ->
      cond do
        is_list(x) -> acc ++ flatten(x)
        x == nil -> acc
        true -> acc ++ [x]
      end
    end)
  end
end
