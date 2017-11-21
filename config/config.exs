# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ex_repository,
  ecto_repos: [ExRepository.Repo]

# Configures the endpoint
config :ex_repository, ExRepositoryWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0UnPY6A6Ekt3l6uMA0gRmX+D6gQv/2iS53w9C74LSd0Etaaxck5CaQiXoPCOCNM6",
  render_errors: [view: ExRepositoryWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ExRepository.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
