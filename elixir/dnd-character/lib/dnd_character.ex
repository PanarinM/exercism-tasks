defmodule DndCharacter do
  @type t :: %__MODULE__{
          strength: pos_integer(),
          dexterity: pos_integer(),
          constitution: pos_integer(),
          intelligence: pos_integer(),
          wisdom: pos_integer(),
          charisma: pos_integer(),
          hitpoints: pos_integer()
        }

  defstruct ~w[strength dexterity constitution intelligence wisdom charisma hitpoints]a

  @spec modifier(pos_integer()) :: integer()
  def modifier(score) do
    score - 10
    |> Kernel./(2)
    |> Float.floor
    |> round
  end

  @doc """
  Rolls four 6-sided dice, and sums largest 3 values
  """
  @spec ability :: pos_integer()
  def ability do
    Enum.map(1..4, fn _ -> :rand.uniform(6) end)
    |> Enum.sort(:desc)
    |> Enum.slice(0..2)
    |> Enum.sum
  end

  @spec character :: t()
  def character do
    %DndCharacter{
      strength: ability(),
      dexterity: ability(),
      constitution: ability(),
      intelligence: ability(),
      wisdom: ability(),
      charisma: ability(),
      hitpoints: 10 + (ability() |> modifier())
    }
  end
end
