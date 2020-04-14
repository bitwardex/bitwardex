defmodule BitwardexWeb.ForceSSLPlug do
  @behaviour Plug

  @impl true
  def init(_opts), do: []

  @impl true
  def call(conn, _opts) do
    opts = Plug.SSL.init(get_config())

    Plug.SSL.call(conn, opts)
  end

  defp get_config do
    Application.get_env(:bitwardex, __MODULE__, Keyword.new())
  end
end
