defmodule MatchingBrackets do
  @bracks %{
    "(" => ")",
    "[" => "]",
    "{" => "}",
  }

  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    ~r/[\(\)\{\}\[\]]/
    |> Regex.scan(str)
    |> List.flatten
    |> matcher([])
  end

  def matcher([], []), do: true
  def matcher([], _), do: false
  def matcher([val | enum], []) do
    if val in Map.keys(@bracks) do
      matcher(enum, [val])
    else
      false
    end
  end
  def matcher([val | enum], stack) do
    if val in Map.keys(@bracks) do
      matcher(enum, [val | stack])
    else
      [head | tail] = stack
      cond do
        val == @bracks[head] -> matcher(enum, tail)
        true -> false
      end
    end
  end
end
