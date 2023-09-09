defmodule Servy.BearController do
  alias Servy.Bear
  alias Servy.Conv
  alias Servy.Wildthings

  @templates_path Path.expand("../../templates", __DIR__)

  defp render(conv, template, bindings) do
    content = @templates_path |> Path.join(template) |> EEx.eval_file(bindings)
    %{conv | status: 200, resp_body: content}
  end

  def index(%Conv{} = conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_by_name/2)

    render(conv, "index.html.eex", bears: bears)
  end

  def show(%Conv{} = conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    render(conv, "show.html.eex", bear: bear)
  end

  def create(%Conv{} = conv, %{"name" => name, "type" => type}) do
    %{conv | status: 201, resp_body: "Created a #{type} bear named #{name}"}
  end
end
