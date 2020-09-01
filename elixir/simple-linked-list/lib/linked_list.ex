defmodule LinkedList do
  @opaque t :: tuple()

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new(), do: {}

  @doc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push(list, elem), do: {elem, list}

  @doc """
  Calculate the length of a LinkedList
  """
  @spec length(t) :: non_neg_integer()
  def length({_, tail}) do
    1 + LinkedList.length(tail)
  end
  def length({}), do: 0

  @doc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?({}), do: true
  def empty?(_), do: false

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek({}), do: {:error, :empty_list}
  def peek({val, _}), do: {:ok, val}

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail({}), do: {:error, :empty_list}
  def tail({_, tl}), do: {:ok, tl}

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop({}), do: {:error, :empty_list}
  def pop({h, tl}), do: {:ok, h, tl}

  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list([]), do: new()
  def from_list(list) do
    # Your implementation here...
    Enum.reduce(list, new(), fn elem, acc ->
      push(acc, elem)
    end)
    |> reverse
  end

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list({}), do: []
  def to_list({elem, {}}), do: [elem]
  def to_list({h, tl}), do: [h] ++ to_list(tl)

  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse({}), do: {}
  def reverse(list), do: reverse(list, {})

  defp reverse({h, tl}, new), do: reverse(tl, push(new, h))
  defp reverse({}, new), do: new
end
