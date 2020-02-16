defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind(a, b, c) do
    case correct?(a, b, c) do
      {false, message} -> {:error, message}
      {true, _} ->
        cond do
          Enum.all?([a, b, c], fn x -> x == a end) -> {:ok, :equilateral}
            Enum.any?([
              [a, b],
              [b, c],
              [c, a],
            ], fn [x, y] -> x == y end) -> {:ok, :isosceles}
          true -> {:ok, :scalene}
        end
    end
  end

  @spec correct?(number, number, number) :: {boolean, String.t()}
  defp correct?(a, b, c) do
    cond do
      not Enum.all?([a, b, c], fn x -> x > 0 end) -> {false, "all side lengths must be positive"}
      not Enum.all?(
        [{[a, b], c},
         {[b, c], a},
         {[c, a], b},],
        fn {sides, x} -> Enum.sum(sides) > x end) -> {false, "side lengths violate triangle inequality"}
        true -> {true, ""}
    end
  end
end
