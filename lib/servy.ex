defmodule Servy do
  use Application

  def start(_start_type, _start_args) do
    IO.puts("Starting Servy...")
    Servy.Supervisor.start_link()
  end
end
