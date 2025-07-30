defmodule BoutiqueInventory do
  def sort_by_price(inventory) do
    Enum.sort(
      inventory,
      fn %{price: price1}, %{price: price2} -> price1 <= price2 end
    )
  end

  def with_missing_price(inventory) do
    Enum.filter(inventory, fn
      %{price: nil} -> true
      %{price: _} -> false
    end)
  end

  def update_names(inventory, old_word, new_word) do
    Enum.reduce(inventory, [], fn %{name: name} = item, acc ->
      new_name = String.replace(name, old_word, new_word, global: true)
      [%{item | name: new_name} | acc]
    end)
    |> Enum.reverse()
  end

  def increase_quantity(%{quantity_by_size: q} = item, count) do
    quantity = Enum.into(q, %{}, fn {size, count_} -> {size, count_ + count} end)
    %{item | quantity_by_size: quantity}
  end

  def total_quantity(%{quantity_by_size: q}) do
    Enum.reduce(q, 0, fn {_, count}, acc -> acc + count end)
  end
end
