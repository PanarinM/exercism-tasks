defmodule Roman do
  @doc """
  Convert the number to a roman number.
  """
  @numerals_map %{1 => "I", 4 => "IV", 5 => "V", 9 =>  "IX", 10 => "X", 40 => "XL", 50 => "L",
                  90 => "XC", 100 => "C", 400 => "CD", 500 => "D", 900 => "CM", 1000 => "M"}
  @spec numerals(pos_integer) :: String.t()
  def numerals(number) do
    {_, result} = @numerals_map
    |> Map.to_list
    |> Enum.sort(fn {key, _}, {key2, _} -> key > key2 end)
    |> Enum.reduce({number, ""}, fn {key, value}, {num, res} ->
      repeat = if num >= key do
          div(num, key)
      else
        0
      end
      {num - repeat * key, res <> String.duplicate(value, repeat)}
    end)
    result
  end

end
