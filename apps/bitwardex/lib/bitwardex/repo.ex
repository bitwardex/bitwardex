defmodule Bitwardex.Repo do
  use Ecto.Repo,
    otp_app: :bitwardex,
    adapter: Ecto.Adapters.Postgres
end
