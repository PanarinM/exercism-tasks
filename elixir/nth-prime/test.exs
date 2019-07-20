defmodule Test do
  def test do
    Enum.reduce(1..100, [], fn x, acc ->
      acc ++ Enum.map(x..100, fn y ->
      x + y + 2*x*y
    end)
    end)
  end
end
