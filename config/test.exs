import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :rumours, Rumours.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "rumours_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rumours, RumoursWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "bG2+i0t9Ny7amynHplSIEDAEB7drSWpq/2ngSvDcLl2JJOANf7LG1FTd6RqBUvYL",
  server: false

# In test we don't send emails.
config :rumours, Rumours.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

config :rumours, :token, new_account_salt: "tokennewaccounts@lttest"
config :rumours, :website, domain: "website_domain_test"
