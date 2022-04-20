defmodule ShortenApi.Plug.REST do
  import Plug.Conn
  alias Plug.Conn.Query

  def init(opts), do: opts

  def call(conn, _opts) do
    res = case conn.method do
      "GET" -> handle_get(conn)
    end
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, to_json(conn, res))
  end

  defp handle_get(conn) do
    url = Query.decode(conn.query_string)["url"]
    if url == "" || is_nil(url) do
      {:error, "Parameter error"}
    else
      hash_id = ShortenApi.HashId.generate(url)
      {:ok, hash_id}
    end
  end

  defp to_json(conn, {:ok, hash_id}) do
    [host_url | _tail] = get_req_header(conn, "host")
    Jason.encode!(%{ok: true, body: "#{conn.scheme}://#{host_url}/#{hash_id}"})
  end

  defp to_json(_conn, {:error, msg}) do
    Jason.encode!(%{ok: false, message: msg})
  end
end
