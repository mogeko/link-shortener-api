defmodule ShortenApi.Plug.REST do
  import Plug.Conn
  alias Plug.Conn.Query

  def init(opts), do: opts

  def call(conn, _opts) do
    res = case conn.method do
      "GET" -> handle_get(conn)
      "POST" -> handle_post(conn)
    end
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, to_json(conn, res))
  end

  defp handle_get(conn) do
    conn.query_string
    |> Query.decode()
    |> Map.fetch("url")
    |> ShortenApi.HashId.generate()
  end

  defp handle_post(conn) do
    conn.params
    |> Map.fetch("url")
    |> ShortenApi.HashId.generate()
  end

  defp to_json(conn, {:ok, hash_id}) do
    [host_url | _tail] = get_req_header(conn, "host")
    Jason.encode!(%{ok: true, short_link: "#{conn.scheme}://#{host_url}/#{hash_id}"})
  end

  defp to_json(_conn, :error) do
    Jason.encode!(%{ok: false, message: "Parameter error"})
  end
end
