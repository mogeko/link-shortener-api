import Config

config :shorten_api, ShortenApi.Repo,
  database: "shorten_db",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :shorten_api, ecto_repos: [ShortenApi.Repo]

config :shorten_api, cowboy_port: 8080
