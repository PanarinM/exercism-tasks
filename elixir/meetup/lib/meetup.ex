defmodule Meetup.Month do

  defstruct [
    monday: [],
    tuesday: [],
    wednesday: [],
    thursday: [],
    friday: [],
    saturday: [],
    sunday: [],
  ]

  @weekday_map %{
    1 => :monday,
    2 => :tuesday,
    3 => :wednesday,
    4 => :thursday,
    5 => :friday,
    6 => :saturday,
    7 => :sunday,
}

  @spec construct(pos_integer, pos_integer) :: {:ok, %Meetup.Month{}} | {:error, String.t}
  def construct(year, month) do
    if Calendar.ISO.valid_date?(year, month, 1) do
      last_day = Calendar.ISO.days_in_month(year, month)
      {:ok, start} = Date.new(year, month, 1)
      {:ok, last} = Date.new(year, month, last_day)
      {:ok, Date.range(start, last) |> parse_month}
    else
      {:error, "not valid year|month combination #{year}-#{month}"}
    end
  end

  @spec parse_month(%Date.Range{}) :: %Meetup.Month{}
  defp parse_month(range) do
    Enum.reduce(range, %Meetup.Month{}, fn day, acc ->
      Map.update!(
        acc,
        Map.get(@weekday_map, Date.day_of_week(day)),
        fn val -> val ++ [day] end
      )
    end)
  end
end


defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @teenth 13..19

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date()
  def meetup(year, month, weekday, schedule) do
    case Meetup.Month.construct(year, month) do
      {:ok, month_struct} -> get_meetup_date(month_struct, weekday, schedule)
      {:error, message} -> {:error, message}
    end
  end

  @doc """
  Get a meetup date from `%Meetup.Month` struct
  """
  @spec get_meetup_date(%Meetup.Month{}, weekday, schedule) :: :calendar.date()
  def get_meetup_date(month_struct, weekday, :first), do: Map.get(month_struct, weekday) |> List.first
  def get_meetup_date(month_struct, weekday, :second), do: Map.get(month_struct, weekday) |> Enum.at(1)
  def get_meetup_date(month_struct, weekday, :third), do: Map.get(month_struct, weekday) |> Enum.at(2)
  def get_meetup_date(month_struct, weekday, :fourth), do: Map.get(month_struct, weekday) |> Enum.at(3)
  def get_meetup_date(month_struct, weekday, :last), do: Map.get(month_struct, weekday) |> List.last
  def get_meetup_date(month_struct, weekday, :teenth) do
    Map.get(month_struct, weekday)
    |> Enum.find(fn day -> day.day in @teenth end)
  end
end
