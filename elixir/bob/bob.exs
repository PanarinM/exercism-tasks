defmodule Bob do
  def hey(input) do
    cond do
      yelled_question?(input) -> "Calm down, I know what I'm doing!"
      yelled?(input) -> "Whoa, chill out!"
      simple_question?(input) -> "Sure."
      silence?(input) -> "Fine. Be that way!"
      true -> "Whatever."
    end
  end

  defp upcase?(string) do
    cond do
      String.upcase(string) != String.downcase(string) ->
        String.upcase(string) == string
      true -> false
    end
  end

  defp yelled?(string), do: upcase?(string)

  defp yelled_question?(string), do: yelled?(string) and String.ends_with?(string, "?")

  defp simple_question?(string), do: String.ends_with?(string, "?")

  defp silence?(string) do
    string = String.trim(string)
    string == ""
  end
end
