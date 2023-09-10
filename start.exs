{:ok, pid} = Servy.PledgeServer.start()

Servy.PledgeServer.create_pledge( "John", 100) |> IO.inspect()
Servy.PledgeServer.create_pledge( "Al", 200) |> IO.inspect()
Servy.PledgeServer.create_pledge( "Jack", 50) |> IO.inspect()
Servy.PledgeServer.create_pledge( "Daisy", 600) |> IO.inspect()

Servy.PledgeServer.clear() |> IO.inspect()
Servy.PledgeServer.create_pledge( "Helena", 100) |> IO.inspect()

Servy.PledgeServer.recent_pledges() |> IO.inspect()
Servy.PledgeServer.total_pledged() |> IO.inspect()

send(pid, {:stop, "hammertime"})

Servy.HttpServer.start(4000)
