defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %Conv{
      method: method,
      path: path,
      resp_body: "HTTP/1.1",
      status: nil
    }
  end
end
