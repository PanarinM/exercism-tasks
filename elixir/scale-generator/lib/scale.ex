defmodule ScaleGenerator.Scale do
  @moduledoc """
  Zipper for a scale.
  """
  @scale ~w(A A# B C C# D D# E F F# G G#)
  @flat_scale ~w(A Bb B C Db D Eb E F Gb G Ab)

  @spec scale(letter :: String.t()) :: List[String.t()]
  def scale(letter \\ "A") do
    letter
    |> String.capitalize()
    |> zip_scale(@scale)
  end

  @spec flat_scale(letter :: String.t()) :: List[String.t()]
  def flat_scale(letter \\ "A") do
    letter
    |> String.capitalize()
    |> zip_scale(@flat_scale)
  end

  @spec zip_scale(letter :: String.t(), scale :: List[String.t]) :: List[String.t()]
  defp zip_scale(letter, scale) do
    Enum.reduce_while(scale, scale, fn
      _, [head | tail] when letter === head -> {:halt, [head | tail] ++ [head]}
      _, [head | tail] -> {:cont, tail ++ [head]}
    end)
  end

  def zip_by(scale, step) do
    Enum.at(scale, step)
    |> scale()
  end


end
