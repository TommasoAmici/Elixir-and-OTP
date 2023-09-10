defmodule Servy.HttpServer do
  def start(port) when is_integer(port) and port > 1023 do
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    IO.puts("Listening on port #{port}")
    accept_loop(listen_socket)
  end

  def accept_loop(listen_socket) do
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)
    spawn(Servy.HttpServer, :serve, [client_socket])
    accept_loop(listen_socket)
  end

  def serve(client_socket) do
    client_socket
    |> read_request
    |> Servy.Handler.handle()
    |> write_response(client_socket)
  end

  def read_request(client_socket) do
    {:ok, request} = :gen_tcp.recv(client_socket, 0)
    request
  end

  def write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket, response)
    :gen_tcp.close(client_socket)
  end
end
