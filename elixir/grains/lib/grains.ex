defmodule Grains do
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer) :: {:ok, pos_integer} | {:error, String.t}
  def square(number) when number >= 1 and number <= 64 do
    {:ok, :math.pow(2, number - 1) |> trunc}
  end
  def square(_), do: {:error, "The requested square must be between 1 and 64 (inclusive)"}

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: {:ok, pos_integer}
  def total do
    {:ok, Enum.map(1..64, fn x ->
        {:ok, val} = square(x)
        val
      end)
      |> Enum.sum}
  end
end
