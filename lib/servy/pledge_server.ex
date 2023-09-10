defmodule Servy.PledgeServer do
  @name :pledge_server

  def start do
    IO.puts("Starting pledge server...")
    pid = spawn(__MODULE__, :listen_loop, [[]])
    Process.register(pid, @name)
    pid
  end

  def listen_loop(state) do
    receive do
      {sender, {:create_pledge, name, amount}} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        new_state = [{name, amount} | state |> Enum.take(2)]
        send(sender, {:response, id})
        listen_loop(new_state)

      {sender, :recent_pledges} ->
        send(sender, {:response, state})
        listen_loop(state)

      {sender, :total_pledged} ->
        total = state |> Enum.map(&elem(&1, 1)) |> Enum.sum()
        send(sender, {:response, total})
        listen_loop(state)

      unexpected ->
        IO.puts("Unpexected message #{inspect(unexpected)}")
        listen_loop(state)
    end
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  def call(pid, message) do
    send(pid, {self(), message})

    receive do
      {:response, response} ->
        response
    end
  end

  def create_pledge(name, amount) do
    call(@name, {:create_pledge, name, amount})
  end

  def recent_pledges() do
    call(@name, :recent_pledges)
  end

  def total_pledged() do
    call(@name, :total_pledged)
  end
end
