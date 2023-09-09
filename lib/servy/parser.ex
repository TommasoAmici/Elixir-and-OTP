defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [top, body] = String.split(request, "\n\n")

    [request_line | _headers] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")

    %Conv{
      method: method,
      path: path,
      params: parse_params(body)
    }
  end

  def parse_params(body) do
    body |> String.trim() |> URI.decode_query()
  end
end
