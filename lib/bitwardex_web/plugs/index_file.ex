defmodule BitwardexWeb.IndexFilePlug do
  @behaviour Plug

  @impl true
  def init(_opts), do: []

  @impl true
  def call(%Plug.Conn{path_info: []} = conn, _opts),
    do: %{conn | request_path: "/index.html", path_info: ["index.html"]}

  def call(conn, _opts), do: conn
end
