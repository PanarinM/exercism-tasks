defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @az_c ?A..?Z
  @az ?a..?z
  @len 26
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    shift = rem(shift, @len)
    to_charlist(text)
    |> Enum.map(fn x ->
      cond do
        x in @az_c ->
          rotate_letter(x, @az_c.last, shift)
        x in @az ->
          rotate_letter(x, @az.last, shift)
        true -> x
      end
    end)
    |> to_string
  end

  defp rotate_letter(number, right, shift) do
    number = number + shift
    if number > right do
      number - @len
    else
      number
    end
  end
end
