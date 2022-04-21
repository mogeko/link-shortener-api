defmodule ShortenApi.Router do
  @moduledoc false
  use Plug.Router
  import Plug.Conn

  plug(Plug.Logger)
  plug(Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Jason)
  plug(:match)
  plug(:dispatch)

  get "/" do
    [host_url | _tail] = get_req_header(conn, "host")
    res = Jason.encode!(%{message: "#{conn.scheme}://#{host_url}/api/v1"})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, res)
  end

  forward("/api/v1", to: ShortenApi.Plug.REST)

  match _ do
    res = Jason.encode!(%{message: "Not Found"})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, res)
  end
end
