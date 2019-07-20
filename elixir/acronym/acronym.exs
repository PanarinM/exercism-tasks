defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    string |> String.split |> Enum.flat_map(&(Regex.scan(~r/\A\w|\p{Lu}/u, &1)))
    |> Enum.join("")
    |> String.upcase
  end
end
