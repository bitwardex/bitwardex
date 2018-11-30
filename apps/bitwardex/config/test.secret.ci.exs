# Since configuration is shared in umbrella projects, this file
# should only configure the :bitwardex application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :bitwardex, Bitwardex.Repo,
  username: "postgres",
  password: "postgres",
  database: "bitwardex_test",
  hostname: "localhost"
