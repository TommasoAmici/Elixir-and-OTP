defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [top, body] = String.split(request, "\n\n")

    [request_line | headers_lines] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")

    %Conv{
      method: method,
      path: path,
      params: parse_params(body),
      headers: parse_headers(%{}, headers_lines)
    }
  end

  def parse_params(body) do
    body |> String.trim() |> URI.decode_query()
  end

  def parse_headers(headers, []), do: headers

  def parse_headers(headers, [head | tail]) do
    [key, value] = String.split(head, ": ")
    parse_headers(Map.put(headers, key, value), tail)
  end
end
