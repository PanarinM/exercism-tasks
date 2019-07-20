defmodule RobotSimulator do
  @directions [:north, :east, :south, :west]
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0}) do
    case position do
      {x, y} when direction not in @directions-> {:error, "invalid direction"}
      {x, y} when is_integer(x) and is_integer(y) -> %{direction: direction, position: position}
      _ -> {:error, "invalid position"}
    end
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    Enum.reduce(String.graphemes(instructions), robot, fn x, y ->
      move(x, y)
    end)
  end

  defp move("R", robot = %{direction: :north}), do: %{robot | direction: :east}
  defp move("R", robot = %{direction: :east}), do: %{robot | direction: :south}
  defp move("R", robot = %{direction: :south}), do: %{robot | direction: :west}
  defp move("R", robot = %{direction: :west}), do: %{robot | direction: :north}

  defp move("L", robot = %{direction: :north}), do: %{robot | direction: :west}
  defp move("L", robot = %{direction: :east}), do: %{robot | direction: :north}
  defp move("L", robot = %{direction: :south}), do: %{robot | direction: :east}
  defp move("L", robot = %{direction: :west}), do: %{robot | direction: :south}

  defp move("A", robot = %{position: {x, y}, direction: :north}), do: %{robot | position: {x, y + 1}}
  defp move("A", robot = %{position: {x, y}, direction: :east}), do: %{robot | position: {x + 1, y}}
  defp move("A", robot = %{position: {x, y}, direction: :south}), do: %{robot | position: {x, y - 1}}
  defp move("A", robot = %{position: {x, y}, direction: :west}), do: %{robot | position: {x - 1, y}}

  defp move(_, _) do
    {:error, "invalid instruction"}
  end
  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(%{direction: direction}), do: direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(%{position: position}), do: position
end
