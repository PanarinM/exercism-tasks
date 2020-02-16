defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    candidates = remove_same(base, candidates)

    String.downcase(base)
    |> String.graphemes
    |> Enum.sort(:asc)
    |> do_match(candidates, [])
  end

  defp do_match(_, [], result), do: result
  defp do_match(base, [candidate | tail], result) do
    String.downcase(candidate)
    |> String.graphemes
    |> Enum.sort(:asc)
    |> case do
         ^base -> do_match(base, tail, result ++ [candidate])
         _ -> do_match(base, tail, result)
       end
  end

  defp remove_same(base, candidates) do
    Enum.filter(candidates, fn x ->
      String.downcase(x) != String.downcase(base)
    end)
  end
end
