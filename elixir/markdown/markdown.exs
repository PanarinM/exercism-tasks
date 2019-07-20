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
    |> group_by()
    |> join_groups
  end

  @doc """
    Groups lines into a keyword list.

    ## Examples

    iex> Markdown.group_by [a: "foo", a: "bar", b: "spam", a: "eggs"]
    [a: ["foo", "bar"], b: ["spam"], a: "eggs"]
  """
  @spec group_by(keyword(String.t())) :: keyword(list(String.t()))
  def group_by(lines) do
    Enum.reduce(lines, [], fn {group, line}, acc ->
      case acc do
        [h | t] ->
          case h do
            {^group, _} ->
              [{group, elem(h, 1) ++ [line]} | t]

            _ ->
              [{group, [line]} | acc]
          end

        [] ->
          [{group, [line]}]
      end
    end)
    |> Enum.reverse()
  end

  def join_groups(groups) do
    Enum.reduce(groups, [], fn {group, lines}, acc ->
      case group do
        :list ->
          line =
            lines
            |> Enum.join()
            |> enclose_with_tag("ul")

          acc ++ [line]

        _ ->
          line =
            lines
            |> Enum.join()

          acc ++ [line]
      end
    end)
    |> Enum.join()
  end

  defp process(row) do
    cond do
      String.starts_with?(row, "#") ->
        line =
          row
          |> String.split(" ", parts: 2)
          |> parse_header_md_level
          |> enclose_with_tag

        {:header, line}

      String.starts_with?(row, "*") ->
        line = parse_list_md_level(row)
        {:list, line}

      true ->
        line =
          row
          |> replace_md_with_tag
          |> enclose_with_tag("p")

        {:text, line}
    end
  end

  defp parse_header_md_level([h | t]), do: {t, "h#{String.length(h)}"}

  defp parse_list_md_level(list_line) do
    list_line
    |> String.trim_leading("* ")
    |> replace_md_with_tag
    |> enclose_with_tag("li")
  end

  defp enclose_with_tag({s, tag}), do: "<#{tag}>#{s}</#{tag}>"
  defp enclose_with_tag(s, tag), do: "<#{tag}>#{s}</#{tag}>"

  defp replace_word(w, reg, tag) do
    cond do
      w =~ reg ->
        Regex.replace(reg, w, fn _, text ->
          enclose_with_tag(text, tag)
        end)

      true ->
        w
    end
  end

  defp replace_md_with_tag(w) do
    strong_re = ~r/__(.+?)__/
    em_re = ~r/_(.+?)_/

    w
    |> replace_word(strong_re, "strong")
    |> replace_word(em_re, "em")
  end
end
