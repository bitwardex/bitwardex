# Since configuration is shared in umbrella projects, this file
# should only configure the :bitwardex application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :bitwardex,
  ecto_repos: [Bitwardex.Repo]


config :bitwardex, :generators,
  migration: true,
  binary_id: false,
  sample_binary_id: "11111111-1111-1111-1111-111111111111"

import_config "#{Mix.env()}.exs"
