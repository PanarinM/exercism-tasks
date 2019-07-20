defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  def reduce([], acc, _), do: acc

  def reduce([head | tail], acc, f) do
    reduce(tail, f.(head, acc), f)
  end

  def count(l) do
    reduce(l, 0, fn _, acc -> acc + 1 end)
  end

  def reverse(l) do
    reduce(l, [], fn x, acc -> [x | acc] end)
  end

  def map(l, f) do
    reduce(l, [], fn x, acc -> [f.(x) | acc] end)
    |> reverse
  end

  def filter(l, f) do
    reduce(l, [], fn x, acc ->
      cond do
        f.(x) -> [x | acc]
        true -> acc
      end
    end)
    |> reverse
  end

  def append([head | tail], b), do: [head | append(tail, b)]
  def append([], b), do: b

  def concat(l) do
    l
    |> reverse
    |> reduce([], fn x, acc ->
      append(x, acc)
    end)
  end

end
