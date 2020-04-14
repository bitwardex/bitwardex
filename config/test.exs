use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bitwardex, BitwardexWeb.Endpoint,
  http: [port: 4002],
  server: false

config :bitwardex, BitwardexWeb.Guardian,
  issuer: "Bitwardex",
  secret_key: "FrWXxI962QiA+Z1yzdT8OhL3JDn/wUtIzieCLp3W8thAvTOwgUDOMPj1XJ8HyE9Q"

# Configure your database
config :bitwardex, Bitwardex.Repo, pool: Ecto.Adapters.SQL.Sandbox

# Print only warnings and errors during test
config :logger, level: :warning

# Import secrets
import_config("test.secret.exs")
