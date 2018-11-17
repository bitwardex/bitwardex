# Since configuration is shared in umbrella projects, this file
# should only configure the :bitwardex_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :bitwardex_web,
  ecto_repos: [Bitwardex.Repo],
  generators: [context_app: :bitwardex]

# Configures the endpoint
config :bitwardex_web, BitwardexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QIKegsGS3oGoSvg6LppC7txk5LaLT06wS5lCh3AWXcDpobTXFoH6Ogz+kigZKyH5",
  render_errors: [view: BitwardexWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: BitwardexWeb.PubSub, adapter: Phoenix.PubSub.PG2]

config :bitwardex_web, :generators, context_app: :bitwardex

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
