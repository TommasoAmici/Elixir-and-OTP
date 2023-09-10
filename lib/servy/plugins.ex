defmodule Servy.Plugins do
  @moduledoc """
  Handles HTTP requests.
  """

  alias Servy.Conv

  def log(%Conv{} = conv) do
    if Mix.env() == :dev do
      IO.puts("#{conv.method} #{conv.path}")
    end

    conv
  end

  @doc """
  Tracks 404s.
  """
  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env() != :test do
      IO.puts("Warning: #{path} is on the loose")
    end

    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{} = conv), do: conv
end
