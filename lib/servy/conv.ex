defmodule Servy.Conv do
  defstruct method: "",
            path: "",
            resp_content_type: "text/html",
            resp_body: "",
            status: nil,
            params: %{},
            headers: %{}

  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
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
