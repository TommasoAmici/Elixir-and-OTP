defmodule Servy.PledgeServer do
  @name :pledge_server

  use GenServer

  def init(init_arg) do
    {:ok, init_arg}
  end

  def start() do
    IO.puts("Starting pledge server...")
    GenServer.start(__MODULE__, [], name: @name)
  end

  def handle_cast(:clear, _state) do
    {:noreply, []}
  end

  def handle_call(:total_pledged, _from, state) do
    total = state |> Enum.map(&elem(&1, 1)) |> Enum.sum()
    {:reply, total, state}
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    new_state = [{name, amount} | state |> Enum.take(2)]
    {:reply, id, new_state}
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  def create_pledge(name, amount) do
    GenServer.call(@name, {:create_pledge, name, amount})
  end

  def recent_pledges() do
    GenServer.call(@name, :recent_pledges)
  end

  def total_pledged() do
    GenServer.call(@name, :total_pledged)
  end

  def clear() do
    GenServer.cast(@name, :clear)
  end
end
