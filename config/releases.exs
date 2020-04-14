import Config

{port, _} = System.fetch_env!("PORT") |> Integer.parse()
{external_port, _} = System.fetch_env!("EXTERNAL_PORT") |> Integer.parse()

config :bitwardex, BitwardexWeb.Endpoint,
  http: [
    port: port,
    compress: true
  ],
  url: [
    scheme: System.fetch_env!("SCHEME"),
    host: System.fetch_env!("HOST"),
    port: external_port
  ],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

if System.get_env("FORCE_SSL") in ["1", "true"] do
  config :bitwardex, BitwardexWeb.ForceSSLPlug,
      rewrite_on: [:x_forwarded_proto]
end

config :bitwardex, BitwardexWeb.Guardian, secret_key: System.fetch_env!("GUARDIAN_SECRET_KEY")

# Mailer settings
config :bitwardex, BitwardexWeb.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: System.fetch_env!("SMTP_SERVER"),
  port: System.fetch_env!("SMTP_PORT"),
  username: System.fetch_env!("SMTP_USERNAME"),
  password: System.fetch_env!("SMTP_PASSWORD"),
  tls: :always

# Configure your database
config :bitwardex, Bitwardex.Repo,
  url: System.fetch_env!("DATABASE_URL"),
  pool_size: 8,
  timeout: 60_000

config :bitwardex, Bitwardex.Accounts,
  required_domain: System.fetch_env!("ACCOUNTS_REQUIRED_DOMAIN"),
  create_organizations: System.fetch_env!("ACCOUNTS_CREATE_ORGANIZATIONS")
