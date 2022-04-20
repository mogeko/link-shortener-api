defmodule ShortenApi.Plug.REST do
  @moduledoc """
  A REST Plug for generating short links.
  """
  @behaviour Plug
  import Plug.Conn

  @doc """
  Pass `Plug.opts` to `call/2`
  """
  @spec init(Plug.opts) :: Plug.opts
  def init(opts), do: opts

  @doc """
  Process `Plug.Conn.t`, return the generated short link.
  """
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
