defmodule Bitwardex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: BitwardexWeb.PubSub},
      # Start the database repository
      Bitwardex.Repo,
      # Start the Endpoint (http/https)
      BitwardexWeb.Endpoint
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Bitwardex.Supervisor)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BitwardexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
