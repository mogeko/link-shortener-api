defmodule ShortenApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: ShortenApi.Worker.start_link(arg)
      # {ShortenApi.Worker, arg}
      {Plug.Cowboy, scheme: :http, plug: ShortenApi.Router, options: [port: cowboy_port()]},
      ShortenApi.Repo
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ShortenApi.Supervisor]

    Logger.info("Starting application...")

    Supervisor.start_link(children, opts)
  end

  defp cowboy_port, do: Application.fetch_env!(:shorten_api, :cowboy_port)
end
