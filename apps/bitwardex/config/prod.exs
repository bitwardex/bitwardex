# Since configuration is shared in umbrella projects, this file
# should only configure the :bitwardex application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :bitwardex, Bitwardex.Repo,
  url: "${DATABASE_URL}",
  pool_size: 8,
  timeout: 60_000

config :bitwardex, Bitwardex.Accounts, required_domain: "${ACCOUNTS_REQUIRED_DOMAIN}"
