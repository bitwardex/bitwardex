defmodule BitwardexWeb.SnakizeParamsPlug do
  @moduledoc """
  Transforms CamelCase parameters into snake_case ones.
  """
  @behaviour Plug

  @impl true
  def init(_opts), do: []

  @impl true
  def call(%Plug.Conn{params: params} = conn, _opts) do
    %{conn | params: snakize_params(params)}
  end

  defp snakize_params(params) when is_map(params) do
    Enum.into(params, %{}, &snakize_params/1)
  end

  defp snakize_params(params) when is_list(params), do: Enum.map(params, &snakize_params/1)
  defp snakize_params({key, value}), do: {Macro.underscore(key), snakize_params(value)}
  defp snakize_params(params), do: params
end
