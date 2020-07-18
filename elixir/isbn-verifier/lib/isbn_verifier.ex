defmodule IsbnVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> ISBNVerifier.isbn?("3-598-21507-X")
      true

      iex> ISBNVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    isbn
    |> String.replace("-", "")
    |> transform_isbn
    |> case do
         {:error, _} -> false
         {:ok, numbers} -> check_numbers(numbers)
       end
  end

  @spec transform_isbn(String.t) :: {:error, String.t} | {:ok, [integer]}
  defp transform_isbn(isbn) do
    isbn = String.graphemes(isbn)
    if length(isbn) != 10 do
      {:error, "Invalid isbn length"}
    else
      numbers =  Enum.map(isbn, fn i ->
        cond do
          i == "X" -> 10
          numeric?(i) -> String.to_integer(i)
          true -> false
        end
      end)
      if false in numbers do
        {:error, "Invalid characters in isbn"}
      else
        {:ok, numbers}
      end
    end
  end

  defp numeric?(str) do
    case Float.parse(str) do
      {_num, ""} -> true
      _ -> false
    end
  end

  @spec check_numbers([integer]) :: boolean
  defp check_numbers(numbers) do
    len = length(numbers)
    numbers
    |> Enum.with_index
    |> Enum.map(fn {elem, index} ->
      elem * (len - index)
    end)
    |> Enum.sum
    |> rem(11)
    |> Kernel.==(0)
  end
end
