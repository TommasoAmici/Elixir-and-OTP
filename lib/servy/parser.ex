defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [top, body] = String.split(request, "\r\n\r\n")

    [request_line | headers_lines] = String.split(top, "\r\n")

    [method, path, _] = String.split(request_line, " ")

    headers = parse_headers(%{}, headers_lines)

    %Conv{
      method: method,
      path: path,
      headers: headers,
      params: parse_params(headers["content-type"], body)
    }
  end

  @doc """
  Parses  the given param string of the form `key1=value1&key2=value2`
  into a map with corresponding keys and values.

  ## Examples
  iex> params_string = "name=Baloo&type=Brown"
  iex> Servy.Parser.parse_params("application/x-www-form-urlencoded", params_string)
  %{"name" => "Baloo", "type" => "Brown"}
  iex> Servy.Parser.parse_params("application/json", params_string)
  %{}
  """
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
