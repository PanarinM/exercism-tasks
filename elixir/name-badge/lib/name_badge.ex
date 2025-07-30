defmodule NameBadge do
  def print(id, name, department) do
    department = if department do
      String.upcase(department)
    else
      nil
    end
    print_badge(id, name, department)
  end

  defp print_badge(nil, name, nil), do: "#{name} - OWNER"
  defp print_badge(nil, name, department) when not is_nil(department), do: "#{name} - #{department}"
  defp print_badge(id, name, nil) when not is_nil(id), do: "[#{id}] - #{name} - OWNER"
  defp print_badge(id, name, department), do: "[#{id}] - #{name} - #{department}"
end
