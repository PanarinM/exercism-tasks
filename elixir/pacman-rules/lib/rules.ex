defmodule Rules do
  @spec eat_ghost?(power_pellet_active :: boolean(), touching_ghost :: boolean()) :: boolean()
  def eat_ghost?(true, true), do: true
  def eat_ghost?(_, _), do: false

  @spec score?(touching_power_pellet :: boolean(), touching_dot :: boolean()) :: boolean()
  def score?(_, true), do: true
  def score?(true, _), do: true
  def score?(_, _), do: false

  @spec lose?(power_pellet_active :: boolean(), touching_ghost :: boolean()) :: boolean()
  def lose?(false, true), do: true
  def lose?(_, _), do: false

  @spec win?(
          has_eaten_all_dots :: boolean(),
          power_pellet_active :: boolean(),
          touching_ghost :: boolean()
        ) :: boolean()
  def win?(has_eaten_all_dots, power_pellet_active, touching_ghost),
    do: has_eaten_all_dots and not lose?(power_pellet_active, touching_ghost)
end
