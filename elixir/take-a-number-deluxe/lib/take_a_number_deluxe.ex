defmodule TakeANumberDeluxe do
  alias TakeANumberDeluxe.State
  # Client API

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg)
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine) do
    GenServer.call(machine, :report_state)
  end

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine) do
    GenServer.call(machine, :queue_number)
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    GenServer.call(machine, {:serve_number, priority_number})
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    GenServer.cast(machine, :reset)
  end

  # Server callbacks
  use GenServer

  @impl GenServer
  def init(opts) when is_list(opts) do
    min = Keyword.get(opts, :min_number)
    max = Keyword.get(opts, :max_number)
    auto_shutdown = Keyword.get(opts, :auto_shutdown_timeout, :infinity)

    State.new(min, max, auto_shutdown)
    |> case do
      {:ok, state} -> {:ok, state, auto_shutdown}
      {:error, error} -> {:stop, error}
    end
  end

  def init(_) do
    {:error, :invalid_configuration}
  end

  @impl GenServer
  def handle_call(:report_state, _, %State{auto_shutdown_timeout: timeout} = state) do
    {:reply, state, state, timeout}
  end

  @impl GenServer
  def handle_call(:queue_number, _, %State{auto_shutdown_timeout: timeout} = state) do
    State.queue_new_number(state)
    |> case do
      {:ok, number, state} -> {:reply, {:ok, number}, state, timeout}
      {:error, _} = error -> {:reply, error, state, timeout}
    end
  end

  def handle_call({:serve_number, priority_number}, _, %State{auto_shutdown_timeout: timeout} = state) do
    State.serve_next_queued_number(state, priority_number)
    |> case do
      {:ok, number, state} -> {:reply, {:ok, number}, state, timeout}
      error -> {:reply, error, state, timeout}
    end
  end

  @impl GenServer
  def handle_cast(:reset, %State{min_number: min, max_number: max, auto_shutdown_timeout: auto_shutdown}) do
    {:ok, state} = State.new(min, max, auto_shutdown)
    {:noreply, state, auto_shutdown}
  end

  @impl GenServer
  def handle_info(:timeout, state) do
    {:stop, :normal, state}
  end

  def handle_info(_, %State{auto_shutdown_timeout: auto_shutdown} = state) do
    {:noreply, state, auto_shutdown}
  end
end
