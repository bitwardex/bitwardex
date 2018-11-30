defmodule BitwardexWeb.CurrentUserPlug do
  @moduledoc """
  Transforms CamelCase parameters into snake_case ones.
  """
  @behaviour Plug

  @impl true
  def init(_opts), do: []

  @impl true
  def call(%Plug.Conn{} = conn, _opts) do
    user = BitwardexWeb.Guardian.Plug.current_resource(conn)
    Plug.Conn.assign(conn, :current_user, user)
  end
end
