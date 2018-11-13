# Since configuration is shared in umbrella projects, this file
# should only configure the :bitwardex application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :bitwardex,
  ecto_repos: [Bitwardex.Repo]

import_config "#{Mix.env()}.exs"
