defmodule ShortenApi.Plug.REST do
  import Plug.Conn
  alias Plug.Conn.Query

  def init(opts), do: opts

  def call(conn, _opts) do
    {:ok, hash_id} = case conn.method do
      "GET" -> handle_get(conn)
    end
    res = if conn.port == 80 do
      "#{conn.scheme}://#{conn.host}/#{hash_id}"
    else
      "#{conn.scheme}://#{conn.host}:#{conn.port}/#{hash_id}"
    end
    send_resp(conn, 200, res)
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
end
