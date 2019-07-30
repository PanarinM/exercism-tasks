defmodule BankServer do
  use GenServer

  @doc """
  Start the Bank server
  """
  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state), do: {:ok, state}

  def balance(account) do
    case Process.alive? account do
      true -> GenServer.call(account, :balance)
      _ -> {:error, :account_closed}
    end
  end

  def update(account, amount) do
    case Process.alive? account do
      true -> GenServer.call(account, {:update, amount})
      _ -> {:error, :account_closed}
    end
  end

  def handle_call(:balance, _from, state), do: {:reply, state, state}
  def handle_call({:update, amount}, _from, state), do: {:reply, state + amount, state + amount}

  def stop(account), do: GenServer.stop(account)
end
