defmodule Servy.Bear do
  defstruct id: nil, name: "", type: "", hibernating: false

  def is_grizzly(%Servy.Bear{} = bear) do
    bear.type == "Grizzly"
  end

  def order_by_name(a, b) do
    a.name <= b.name
  end
end
