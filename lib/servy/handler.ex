defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  def log(conv), do: IO.inspect(conv)

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{
      method: method,
      path: path,
      resp_body: "HTTP/1.1",
      status: nil
    }
  end

  def route(conv) do
    route(conv, conv.method, conv.path)
  end

  def route(conv, "GET", "/wildthings") do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(conv, "GET", "/bears") do
    %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def route(conv, "GET", "/bears/" <> id) do
    %{conv | status: 200, resp_body: "Bear #{id}"}
  end

  def route(conv, _method, path) do
    %{conv | status: 404, resp_body: "No #{path} here"}
  end

  def format_response(conv) do
    content_length = conv.resp_body |> byte_size

    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    content-type: text/html
    content-length: #{content_length}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    case code do
      200 -> "OK"
      201 -> "Created"
      202 -> "Accepted"
      204 -> "No Content"
      400 -> "Bad Request"
      401 -> "Unauthorized"
      403 -> "Forbidden"
      404 -> "Not Found"
      405 -> "Method Not Allowed"
      500 -> "Internal Server Error"
    end
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

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: curl/7.43.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: curl/7.43.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: curl/7.43.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)
