defmodule Phone do

  @wrong_number ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
  @doc """
  Remove formatting from a phone number.

  Returns "0000000000" if phone number is not valid
  (10 digits or "1" followed by 10 digits)

  ## Examples

  iex> Phone.number("212-555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 055-0100")
  "0000000000"

  iex> Phone.number("(212) 555-0100")
  "2125550100"

  iex> Phone.number("867.5309")
  "0000000000"
  """
  @spec number(String.t()) :: String.t()
  def number(raw) do
    digits = ~r/[0-9]/
    |> Regex.scan(raw)
    |> List.flatten

    cond do
      length(digits) in [10, 11] -> digits
      true -> @wrong_number
    end
    |> check_digits
    |> Enum.join()
  end

  @spec check_digits([String.t()]) :: [String.t()]
  def check_digits(@wrong_number), do: @wrong_number
  def check_digits(digits) when length(digits) == 11 do
    [country | number] = digits
    case country do
      "1" -> check_digits(number)
      _ -> check_digits(@wrong_number)
    end
  end
  def check_digits(digits) do
    cond do
      Enum.at(digits, 0) |> String.to_integer < 2 -> @wrong_number
      Enum.at(digits, 3) |> String.to_integer < 2 -> @wrong_number
      true -> digits
    end
  end

  @doc """
  Extract the area code from a phone number

  Returns the first three digits from a phone number,
  ignoring long distance indicator

  ## Examples

  iex> Phone.area_code("212-555-0100")
  "212"

  iex> Phone.area_code("+1 (212) 555-0100")
  "212"

  iex> Phone.area_code("+1 (012) 555-0100")
  "000"

  iex> Phone.area_code("867.5309")
  "000"
  """
  @spec area_code(String.t()) :: String.t()
  def area_code(raw) do
    raw
    |> number
    |> String.slice(0..2)
  end

  @doc """
  Pretty print a phone number

  Wraps the area code in parentheses and separates
  exchange and subscriber number with a dash.

  ## Examples

  iex> Phone.pretty("212-555-0100")
  "(212) 555-0100"

  iex> Phone.pretty("212-155-0100")
  "(000) 000-0000"

  iex> Phone.pretty("+1 (303) 555-1212")
  "(303) 555-1212"

  iex> Phone.pretty("867.5309")
  "(000) 000-0000"
  """
  @spec pretty(String.t()) :: String.t()
  def pretty(raw) do
    raw
    |> number
    |> prettify
  end

  defp prettify(number_) do
    "(#{String.slice(number_, 0..2)}) #{String.slice(number_, 3..5)}-#{String.slice(number_, 6..-1)}"
  end
end
