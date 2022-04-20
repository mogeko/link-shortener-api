defmodule ShortenApi.Plug.REST do
  import Plug.Conn

  @spec init(any) :: any
  def init(opts), do: opts

  @spec call(Plug.Conn.t, any) :: Plug.Conn.t
  def call(conn, _opts) do
    IO.inspect(conn)
    res = conn.params
    |> Map.fetch("url")
    |> ShortenApi.HashId.generate()
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, to_json(conn, res))
  end

  defp to_json(conn, {:ok, hash_id}) do
    [host_url | _tail] = get_req_header(conn, "host")
    Jason.encode!(%{ok: true, short_link: "#{conn.scheme}://#{host_url}/#{hash_id}"})
  end

  defp to_json(_conn, :error) do
    Jason.encode!(%{ok: false, message: "Parameter error"})
  end
end
