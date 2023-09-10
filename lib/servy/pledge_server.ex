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
      {sender, message} when is_pid(sender) ->
        {response, new_state} = handle_call(message, state)
        send(sender, {:response, response})
        listen_loop(new_state)

      unexpected ->
        IO.puts("Unpexected message #{inspect(unexpected)}")
        listen_loop(state)
    end
  end

  def handle_call(:total_pledged, state) do
    total = state |> Enum.map(&elem(&1, 1)) |> Enum.sum()
    {total, state}
  end

  def handle_call(:recent_pledges, state) do
    {state, state}
  end

  def handle_call({:create_pledge, name, amount}, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    new_state = [{name, amount} | state |> Enum.take(2)]
    {id, new_state}
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
