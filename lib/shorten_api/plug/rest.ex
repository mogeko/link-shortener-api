defmodule ShortenApi.Plug.REST do
  @behaviour Plug
  import Plug.Conn

  @spec init(Plug.opts) :: Plug.opts
  def init(opts), do: opts

  @spec call(Plug.Conn.t, Plug.opts) :: Plug.Conn.t
  def call(conn, _opts) do
    res = conn.params
    |> Map.fetch("url")
    |> ShortenApi.HashId.generate()
    conn
    |> put_resp_content_type("application/json")
    |> put_resp_msg(res)
    |> send_resp()
  end

  defp put_resp_msg(conn, {:ok, hash_id}) do
    [host_url | _tail] = get_req_header(conn, "host")
    res = Jason.encode!(%{ok: true, short_link: "#{conn.scheme}://#{host_url}/#{hash_id}"})
    resp(conn, 201, res)
  end

  defp put_resp_msg(conn, :error) do
    res = Jason.encode!(%{ok: false, message: "Parameter error"})
    resp(conn, 404, res)
  end
end
