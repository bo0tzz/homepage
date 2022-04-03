import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :homepage, HomepageWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "KY1TKq90Y0Q0Nh2aD4l8iSTSggZW+6ekPFNLSOFUZXN62pKwRwc7seojbJtBcpAq",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
