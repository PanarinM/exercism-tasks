defmodule HighSchoolSweetheart do
  def first_letter(name) do
    name
    |> String.trim()
    |> String.graphemes()
    |> Enum.at(0)
  end

  def initial(name) do
    name
    |> first_letter()
    |> String.capitalize()
    |> then(&(&1 <> "."))
  end

  def initials(full_name) do
    full_name
    |> String.trim()
    |> String.split()
    |> Enum.map_join(" ", &initial/1)
  end

  def pair(full_name1, full_name2) do
    # ❤-------------------❤
    # |  X. X.  +  X. X.  |
    # ❤-------------------❤
    initials_1 = initials(full_name1)
    initials_2 = initials(full_name2)

    """
    ❤-------------------❤
    |  #{initials_1}  +  #{initials_2}  |
    ❤-------------------❤
    """
  end
end
