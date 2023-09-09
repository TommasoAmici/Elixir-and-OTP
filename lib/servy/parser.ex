defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [top, body] = String.split(request, "\n\n")

    [request_line | headers_lines] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")

    headers = parse_headers(%{}, headers_lines)

    %Conv{
      method: method,
      path: path,
      headers: headers,
      params: parse_params(headers["content-type"], body)
    }
  end

  def parse_params("application/x-www-form-urlencoded", body) do
    body |> String.trim() |> URI.decode_query()
  end

  def parse_params(_, _), do: %{}

  def parse_headers(headers, []), do: headers

  def parse_headers(headers, [head | tail]) do
    [key, value] = String.split(head, ": ")
    parse_headers(Map.put(headers, key |> String.downcase(), value), tail)
  end
end
