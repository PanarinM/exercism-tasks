defmodule Frame do
  @type t :: %__MODULE__{
    type: :open | :spare | :strike,
    throws: [integer],
  }
  @enforce_keys [:type]
  defstruct [:type, throws: []]
end

defmodule Bowling do
  # add Game API calls
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  @spec start() :: pid | nil
  def start do
    case Game.start() do
	    {:ok, pid} -> pid
      {:error, _} -> nil
    end
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """

  @spec roll(pid, integer) :: any | String.t()
  def roll(game, roll) do
    case Game.roll(game, roll) do
      error = {:error, _} -> error
      _ -> game
    end
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """

  @spec score(pid) :: integer | String.t()
  def score(game) do
    Game.game_score(game)
  end
end

defmodule Game do
	use Agent

  @frames_in_game 10
  @pins_in_game 10

  @spec start({[%Frame{}], []}) :: {:ok, pid} | {:error, %{}}
  def start(initial_data \\ {[], []}) do
    Agent.start_link(fn -> initial_data end)
  end

  def last_frame?(game) do
    {frames, _} = get_state(game)
    length(frames) == @frames_in_game - 1
  end

  defp handle_last_frame_roll(game, value) do
    {frames, rolls} = get_state(game)
    cond do
      length(rolls) == 2 ->
        cond do
          Enum.sum(rolls) == @pins_in_game ->
            add_frame(game, %Frame{type: :open, throws: [value | rolls]})
          List.first(rolls) != @pins_in_game and List.first(rolls) + value > @pins_in_game ->
            {:error, "Pin count exceeds pins on the lane"}
          true ->
            add_frame(game, %Frame{type: :spare, throws: [value | rolls]})
        end
      length(rolls) == 1 and Enum.sum(rolls) + value < @pins_in_game ->
        add_frame(game, %Frame{type: :open, throws: [value | rolls]})
      true ->
        set_state(game, {frames, [value | rolls]})
    end
  end

  defp handle_frame_roll(game, value) do
    {frames, rolls} = get_state(game)
    cond do
      value == @pins_in_game and length(rolls) == 0 ->
        add_frame(game, %Frame{type: :strike, throws: [value | rolls]})
      Enum.sum(rolls) + value == @pins_in_game and length(rolls) == 1 ->
        add_frame(game, %Frame{type: :spare, throws: [value | rolls]})
      length(rolls) == 1 ->
        add_frame(game, %Frame{type: :open, throws: [value | rolls]})
      true ->
        set_state(game, {frames, [value | rolls]})
    end
  end

  def roll(game, value) do
    {frames, rolls} = get_state(game)
    cond do
      value > @pins_in_game ->
        {:error, "Pin count exceeds pins on the lane"}
      value < 0 ->
        {:error, "Negative roll is invalid"}
      length(frames) == @frames_in_game ->
        {:error, "Cannot roll after game is over"}
      length(rolls) == 1 and Enum.sum(rolls) != @pins_in_game and Enum.sum(rolls) + value > @pins_in_game ->
        {:error, "Pin count exceeds pins on the lane"}
      last_frame?(game) -> handle_last_frame_roll(game, value)
      true -> handle_frame_roll(game, value)
    end
  end

  @spec get_state(pid) :: {[%Frame{}], [integer]}
  def get_state(game) do
    Agent.get(game, fn state -> state end)
  end

  defp add_frame(game, frame) do
    Agent.update(game, fn {frames, _} -> {[frame | frames], []} end)
  end

  defp set_state(game, new_state) do
    Agent.update(game, fn _ -> new_state end)
  end

  def game_score(game) do
    {frames, _} = get_state(game)
    if length(frames) != @frames_in_game do
      {:error, "Score cannot be taken until the end of the game"}
    else
      Enum.with_index(frames, 1)
      |> Enum.reduce([], fn {_, index}, acc -> [get_frame_score(game, index) | acc] end)
      |> Enum.sum
    end
  end

  defp get_frame(game, frame_number) do
    {frames, _} = get_state(game)
    Enum.at(frames, -frame_number)
  end

  @spec get_frame_score(pid, integer) :: integer
  def get_frame_score(game, frame_number) do
    frame_score(game, get_frame(game, frame_number), frame_number)
  end

  defp frame_score(_, frame = %Frame{type: :open}, _) do
    Enum.sum(frame.throws)
  end

  defp frame_score(game, frame = %Frame{type: :spare}, frame_number) do
    {frames, _} = get_state(game)
    frame = cond do
      length(frame.throws) == 3 -> frame
      length(frames) == frame_number -> nil
      true ->
        if frame_number != @frames_in_game do
          next_frame = get_frame(game, frame_number + 1)
          Map.merge(frame, %{throws: [Enum.at(next_frame.throws, -1) | frame.throws ]})
        else
          frame
        end
    end
    Enum.sum(frame.throws)
  end

  defp frame_score(game, frame = %Frame{type: :strike}, frame_number) do
    {frames, _} = get_state(game)
    frame = cond do
      length(frame.throws) == 3 -> frame
      length(frames) == frame_number -> nil
      true ->
        next_frame = get_frame(game, frame_number + 1)
        cond do
          next_frame.type == :strike and frame_number != @frames_in_game - 1 ->
            frame_after = get_frame(game, frame_number + 2)
            Map.merge(frame, %{throws: [Enum.at(frame_after.throws, -1), @pins_in_game] ++ frame.throws})
          true ->
            Map.merge(frame, %{throws: Enum.slice(next_frame.throws, -2..-1) ++ frame.throws})
        end
    end
    Enum.sum(frame.throws)
  end

end
