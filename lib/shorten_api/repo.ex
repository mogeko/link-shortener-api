defmodule ShortenApi.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :shorten_api,
    adapter: Ecto.Adapters.Postgres
end
