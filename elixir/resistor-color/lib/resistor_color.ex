defmodule ResistorColor do
  @moduledoc false

  @res_map [
    {:black, 0},
    {:brown, 1},
    {:red, 2},
    {:orange, 3},
    {:yellow, 4},
    {:green, 5},
    {:blue, 6},
    {:violet, 7},
    {:grey, 8},
    {:white, 9},
  ]

  @spec colors() :: list(String.t())
  def colors do
    Keyword.keys(@res_map)
    |> Enum.map(fn x -> to_string(x) end)
  end

  @spec code(String.t()) :: integer()
  def code(color) do
    color = String.to_atom(color)

    @res_map[color]
  end
end
