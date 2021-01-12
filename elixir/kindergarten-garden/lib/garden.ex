defmodule Garden do
  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """
  @plant_codes %{
    "V" => :violets,
    "R" => :radishes,
    "G" => :grass,
    "C" => :clover
  }

  @kids [
    :alice, :bob, :charlie, :david,
    :eve, :fred, :ginny, :harriet,
    :ileana, :joseph, :kincaid, :larry
  ]


  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @kids) do
    # Sort students alphabetically
    student_names = Enum.sort(student_names)

    plants = for name <- student_names, into: %{}, do: {name, {}}

    # Get properly chunked rows
    [row1, row2] =
      String.split(info_string, "\n")
      |> Enum.map(fn row -> Enum.chunk_every(String.graphemes(row), 2) end)

    # Reduce into final map
    Enum.reduce(
      Enum.zip([row1, row2, student_names]),
      plants,
      fn {plants1, plants2, name}, acc ->
        Map.put(
          acc,
          name,
          # Reduce into tuple of final plant names
          Enum.reduce(
            plants1 ++ plants2,
            {},
            fn plant, acc ->
              Tuple.append(acc, Map.get(@plant_codes, plant))
            end
          )
        )
      end
    )
  end
end
