defmodule Servy.BearController do
  alias Servy.Bear
  alias Servy.Conv
  alias Servy.Wildthings

  defp render_bear(bear) do
    "<li><a href='/bears/#{bear.id}'>#{bear.name}</a></li>"
  end

  def index(%Conv{} = conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_grizzly/1)
      |> Enum.sort(&Bear.order_by_name/2)
      |> Enum.map(&render_bear/1)
      |> Enum.join()

    %{conv | status: 200, resp_body: "<ul>#{bears}</ul>"}
  end

  def show(%Conv{} = conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{conv | status: 200, resp_body: "<h1>#{bear.name}</h1>"}
  end

  def create(%Conv{} = conv, %{"name" => name, "type" => type}) do
    %{conv | status: 201, resp_body: "Created a #{type} bear named #{name}"}
  end
end
