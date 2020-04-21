defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    scores = []

    Enum.reduce(input, scores, fn string, acc ->
      case length([acc | String.split(string, ";")]) do
        4 -> Kernel.apply(&write_results/4, [acc | String.split(string, ";")])
        _ -> acc
      end
    end)
    |> Enum.sort(fn x, y ->
      elem(elem(x, 1), 4) > elem(elem(y, 1), 4)
    end)
    |> format_output
  end

  defp write_results(scores, teamA, teamB, "win") do
    scores
    |> Keyword.update(
      String.to_atom(teamA), {1, 1, 0, 0, 3}, fn {mp, w, d, l, p} ->
      {mp + 1, w + 1, d, l, p + 3}
    end)
    |> Keyword.update(
      String.to_atom(teamB), {1, 0, 0, 1, 0}, fn {mp, w, d, l, p} ->
      {mp + 1, w, d, l + 1, p}
    end)
  end

  defp write_results(scores, teamA, teamB, "draw") do
    scores
    |> Keyword.update(
      String.to_atom(teamA), {1, 0, 1, 0, 1}, fn {mp, w, d, l, p} ->
      {mp + 1, w, d + 1, l, p + 1}
    end)
    |> Keyword.update(
      String.to_atom(teamB), {1, 0, 1, 0, 1}, fn {mp, w, d, l, p} ->
      {mp + 1, w, d + 1, l, p + 1}
    end)
  end

  defp write_results(scores, teamA, teamB, "loss") do
    write_results(scores, teamB, teamA, "win")
  end

  defp write_results(scores, _, _, _) do
    scores
  end

  defp format_output(scores) do
    header = "#{String.pad_trailing(to_string(:Team), 30)} | MP |  W |  D |  L |  P"
    scores = Enum.map(scores, &stringify/1)
    |> Enum.map(fn {key, val} ->
      "#{String.pad_trailing(to_string(key), 30)} |  #{elem(val, 0)} |  #{elem(val, 1)} |  #{elem(val, 2)} |  #{elem(val, 3)} |  #{elem(val, 4)}"
    end)
    [header] ++ scores
    |> Enum.join("\n")
  end

  defp stringify({key, score}) do
    {key, Tuple.to_list(score) |> Enum.map(&to_string/1) |> List.to_tuple()}
  end
end
