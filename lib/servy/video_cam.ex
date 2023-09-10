defmodule Servy.VideoCam do
  def get_snapshot(camer_name) do
    :timer.sleep(1000)
    "#{camer_name}-#{DateTime.utc_now()}.jpg"
  end
end
