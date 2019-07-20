defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(text) do
    text
    |> String.split("\n")
    |> Enum.map(&process/1)
    |> Enum.join()
    |> patch
  end

  defp group_by(lines) do
    # i need my own group_by, just like python one works by default
    Enum.reduce(lines, {}, fn line, acc ->
    end)
  end

  defp process(row) do
    cond do
      String.starts_with?(row, "#") ->
        {string, tag} = row
        |> String.split(" ", parts: 2)
        |> parse_header_md_level
        enclose_with_tag(string, tag)

      String.starts_with?(row, "*") ->
        parse_list_md_level(row)

      true ->
        row
        |> replace_md_with_tag
        |> enclose_with_tag("p")
    end
  end

  defp parse_header_md_level([h | t]), do: {t, "h#{String.length(h)}"}

  defp parse_list_md_level(list_line) do
    list_line
    |> String.trim_leading("* ")
    |> replace_md_with_tag
    |> enclose_with_tag("li")
  end

  defp enclose_with_tag(s, tag), do: "<#{tag}>#{s}</#{tag}>"

  defp replace_md_with_tag(w) do
    strong_re = ~r/__(.+?)__/
    em_re = ~r/_(.+?)_/
    w
    |> replace_word(strong_re, "strong")
    |> replace_word(em_re, "em")
  end

  defp replace_word(w, reg, tag) do
    cond do
      w =~ reg ->
        Regex.replace(reg, w, fn _, text ->
          enclose_with_tag(text, tag)
        end)
     true -> w
    end
  end

  defp patch(l) do
    l
    |> String.replace("<li>", "<ul><li>", global: false)
    |> String.replace_suffix("</li>", "</li></ul>")
  end
end
