# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :midgard,
  ecto_repos: [Midgard.Repo]

# Configures the endpoint
config :midgard, MidgardWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+2HapEa8Au2CvMPW7jwPKCoctjhfqCCKFqNGEGiE6lMzv2Hhxv91y7/IOW+H8cXv",
  render_errors: [view: MidgardWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Midgard.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :midgard, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      # phoenix routes will be converted to swagger paths
      router: MidgardWeb.Router,
      # (optional) endpoint config used to set host, port and https schemes.
      endpoint: MidgardWeb.Endpoint
    ]
  }
