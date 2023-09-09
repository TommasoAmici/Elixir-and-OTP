defmodule ParserTest do
  use ExUnit.Case
  doctest Servy.Parser
  alias Servy.Parser

  test "parses a list of headers into a map" do
    header_lines = [
      "Host: example.com",
      "Content-Type: application/json"
    ]

    headers = Parser.parse_headers(%{}, header_lines)

    assert headers == %{
             "host" => "example.com",
             "content-type" => "application/json"
           }
  end
end
