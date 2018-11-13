defmodule BitwardexWeb.IndexFilePlug do
  @behaviour Plug

  def init(_opts), do: []

  def call(%Plug.Conn{path_info: []} = conn, _opts),
    do: %{conn | request_path: "/index.html", path_info: ["index.html"]}

  def call(conn, _opts), do: conn
end
