defmodule ShortenApi.Router do
  use Plug.Router

  plug Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Jason
  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Welcome")
  end

  forward "/api/v1", to: ShortenApi.Plug.REST

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end