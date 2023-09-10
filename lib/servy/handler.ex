defmodule Servy.Handler do
  @moduledoc """
  Handles HTTP requests.
  """

  @pages_path Path.expand("../../pages", __DIR__)

  import Servy.Parser, only: [parse: 1]
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  alias Servy.BearController
  alias Servy.Conv

  @doc """
  Transforms the request into a response.
  """
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  @doc """
  Handles file reads.
  """
  def handle_file(path, %Conv{} = conv) do
    case File.read(path) do
      {:ok, contents} -> %{conv | status: 200, resp_body: contents}
      {:error, :enoent} -> %{conv | status: 404, resp_body: "File not found"}
      {:error, reason} -> %{conv | status: 500, resp_body: "File error: #{reason}"}
    end
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/snapshots"} = conv) do
    Servy.Fetcher.async(fn -> Servy.VideoCam.get_snapshot("cam-1") end)
    Servy.Fetcher.async(fn -> Servy.VideoCam.get_snapshot("cam-2") end)
    Servy.Fetcher.async(fn -> Servy.VideoCam.get_snapshot("cam-3") end)

    snapshot_1 = Servy.Fetcher.get_result()
    snapshot_2 = Servy.Fetcher.get_result()
    snapshot_3 = Servy.Fetcher.get_result()

    snapshots = [snapshot_1, snapshot_2, snapshot_3]
    %{conv | status: 200, resp_body: inspect(snapshots)}
  end

  def route(%Conv{method: "GET", path: "/kaboom"} = _conv) do
    raise "Kaboom!"
  end

  def route(%Conv{method: "GET", path: "/hibernate/" <> time} = conv) do
    time |> String.to_integer() |> :timer.sleep()
    %{conv | status: 200, resp_body: "Awake!"}
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Servy.Api.BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "POST", path: "/bears", params: params} = conv) do
    BearController.create(conv, params)
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here"}
  end

  def format_response(%Conv{} = conv) do
    content_length = conv.resp_body |> byte_size

    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    content-type: #{conv.resp_content_type}\r
    content-length: #{content_length}\r
    \r
    #{conv.resp_body}
    """
  end
end
