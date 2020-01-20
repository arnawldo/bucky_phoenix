use Mix.Config

# Configure your database
config :bucky_phoenix, BuckyPhoenix.Repo,
  username: "postgres",
  password: "",
  database: "bucky_phoenix_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bucky_phoenix, BuckyPhoenixWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
