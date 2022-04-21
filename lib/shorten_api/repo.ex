defmodule ShortenApi.Repo do
  use Ecto.Repo,
    otp_app: :shorten_api,
    adapter: Ecto.Adapters.Postgres
end
