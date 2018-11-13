[
  inputs: ["mix.exs", "config/*.exs"],
  subdirectories: ["apps/*"],
  import_deps: [:ecto, :ecto_sql, :phoenix]
]
