defmodule BirdCount do
  def today([]), do: nil
  def today([n | _tail]), do: n

  def increment_day_count([]), do: [1]
  def increment_day_count([n | tail]), do: [n + 1 | tail]

  def has_day_without_birds?([]), do: false
  def has_day_without_birds?([0 | _]), do: true
  def has_day_without_birds?([_ | tail]), do: has_day_without_birds?(tail)

  def total(list) do
    total(list, 0)
  end

  defp total([], sum), do: sum
  defp total([val | tail], sum), do: total(tail, val + sum)

  def busy_days(list) do
    busy_days(list, 0)
  end

  defp busy_days([], n), do: n
  defp busy_days([val | tail], n) do
    n =
      if val > 4 do
        n + 1
      else
        n
      end

    busy_days(tail, n)
  end
end
