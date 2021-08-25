# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :bitwardex,
  ecto_repos: [Bitwardex.Repo]

config :bitwardex, :generators,
  migration: true,
  binary_id: false,
  sample_binary_id: "11111111-1111-1111-1111-111111111111"

config :bitwardex, Bitwardex.Accounts,
  required_domain: "",
  create_organizations: true

# General application configuration
config :bitwardex,
  ecto_repos: [Bitwardex.Repo],
  generators: [context_app: :bitwardex]

# Configures the endpoint
config :bitwardex, BitwardexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QIKegsGS3oGoSvg6LppC7txk5LaLT06wS5lCh3AWXcDpobTXFoH6Ogz+kigZKyH5",
  render_errors: [view: BitwardexWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: BitwardexWeb.PubSub

config :bitwardex, :generators, context_app: :bitwardex

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
