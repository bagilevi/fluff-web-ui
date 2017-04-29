# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :fluff,
  ecto_repos: [Fluff.Repo]

# Configures the endpoint
config :fluff, Fluff.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yo4rqe7eF3zZKWEpy/WYao8JyuhhGnOcoJfP4daCPyU3bbwPF4aZREpbSpqgdaQY",
  render_errors: [view: Fluff.ErrorView, accepts: ~w(html json)],
  # pubsub: [name: Fluff.PubSub,
  #          adapter: Phoenix.PubSub.PG2]
  pubsub: [name: Fluff.PubSub,
           adapter: Phoenix.PubSub.Redis,
           node_name: System.get_env("NODE") || "main"]


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
