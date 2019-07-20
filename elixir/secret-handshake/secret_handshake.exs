defmodule SecretHandshake do
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    code
    |> Integer.digits(2)
    |> Enum.reverse
    |> convert_command()
  end

  def convert_command(command) do
    result = command
    |> Enum.zip(["wink", "double blink", "close your eyes", "jump"])
    |> Enum.filter(fn x ->
      case x do
        {1, _} -> true
        {0, _} -> false
      end
    end)
    |> Enum.map(fn {a, b} ->
      b
    end)
    if length(command) >= 5 and Enum.at(command, 4) == 1 do
      Enum.reverse(result)
    else
      result
    end
  end

end
