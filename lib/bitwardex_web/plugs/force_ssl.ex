defmodule BitwardexWeb.ForceSSLPlug do
  @behaviour Plug

  @impl true
  def init(_opts), do: []

  @impl true
  def call(conn, _opts) do
    config = Application.get_env(:bitwardex, __MODULE__, Keyword.new())

    execute(conn, config)
  end

  defp execute(conn, config) when config in [[], nil], do: conn

  defp execute(conn, config) do
    opts = Plug.SSL.init(config)

    Plug.SSL.call(conn, opts)
  end
end
