defmodule Servy.BearController do
  alias Servy.Conv

  def index(%Conv{} = conv) do
    %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def show(%Conv{} = conv, %{"id" => id}) do
    %{conv | status: 200, resp_body: "You asked for bear #{id}"}
  end

  def create(%Conv{} = conv, %{"name" => name, "type" => type}) do
    %{conv | status: 201, resp_body: "Created a #{type} bear named #{name}"}
  end
end
