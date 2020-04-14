use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :bitwardex, BitwardexWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :bitwardex, BitwardexWeb.Guardian,
  issuer: "Bitwardex",
  secret_key: "y60yLN2yKz1Md/hBRCMNkOLRg4/2y2Ib/7Bg0A3yLzuMEFDJvmvtKSCnunP4aNNT"

config :bitwardex, BitwardexWeb.Mailer, adapter: Bamboo.LocalAdapter

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Import secrets
import_config("dev.secret.exs")
