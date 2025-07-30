# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start() do
    Agent.start(fn -> %{id: 1, plots: []} end)
  end

  def list_registrations(pid) do
    Agent.get(pid, &(&1[:plots]))
  end

  def register(pid, register_to) do
    me = self()
    Agent.update(pid, fn
      %{id: id, plots: plots} ->
        plot = %Plot{plot_id: id, registered_to: register_to}
        send(me, plot)
        %{id: id + 1, plots: [plot | plots]}
    end)

    receive do
      msg -> msg
    end
  end

  def release(pid, plot_id) do
    Agent.cast(pid, fn %{plots: plots} = state ->
      plots = Enum.filter(plots, fn
        %{plot_id: ^plot_id} -> false
        _ -> true
      end)
      %{state | plots: plots}
    end)
  end

  def get_registration(pid, plot_id) do
    Agent.get(pid, fn %{plots: plots} ->
      Enum.reduce_while(plots, {:not_found, "plot is unregistered"}, fn
        %{plot_id: ^plot_id} = plot, _acc -> {:halt, plot}
        _plot, acc -> {:cont, acc}
      end)
    end)
  end
end
