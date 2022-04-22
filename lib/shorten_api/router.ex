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
    resp_msg = Jason.encode!(%{message: "#{conn.scheme}://#{host_url}/api/v1"})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, resp_msg)
  end

  forward("/api/v1", to: ShortenApi.Plug.REST)

  get "/:hash" do
    import Ecto.Query, only: [from: 2]
    query = from l in ShortenApi.DB.Link, where: l.hash == ^hash, select: l.url
    url = ShortenApi.Repo.one(query)

    if is_nil(url) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(404, Jason.encode!(%{message: "Not Found"}))
    else
      conn
      |> put_resp_header("location", url)
      |> send_resp(302, "Redirect to #{url}")
    end
  end

  match _ do
    resp_msg = Jason.encode!(%{message: "Not Found"})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, resp_msg)
  end
end
