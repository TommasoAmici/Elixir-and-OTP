defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> route
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, resp_body: "HTTP/1.1"}
  end

  def route(conv) do
    Map.put(conv, :resp_body, "Bears, Lions, Tigers")
  end

  def format_response(conv) do
    content_length = conv.resp_body |> byte_size

    """
    HTTP/1.1 200 OK
    content-type: text/html
    content-length: #{content_length}

    #{conv.resp_body}
    """
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: curl/7.43.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)
