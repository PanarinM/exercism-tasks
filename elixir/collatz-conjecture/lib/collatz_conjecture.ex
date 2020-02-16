defmodule CollatzConjecture do
  require Integer
  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(input) when input > 0 do
    do_calc(input, 0)
  end

  def do_calc(1, counter), do: counter
  def do_calc(number, counter) when Integer.is_even(number) do
    do_calc(div(number, 2), counter + 1)
  end
  def do_calc(number, counter) when Integer.is_odd(number) do
    do_calc(3 * number + 1, counter + 1)
  end
end
