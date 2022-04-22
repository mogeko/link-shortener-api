defmodule ShortenApi.Plug.REST.Resp do
  @moduledoc false
  @derive Jason.Encoder
  defstruct ok: true, short_link: ""
  @type t :: %__MODULE__{ok: boolean, short_link: String.t()}
end

defmodule ShortenApi.Plug.REST.ErrResp do
  @moduledoc false
  @derive Jason.Encoder
  defstruct ok: false, message: ""
  @type t :: %__MODULE__{ok: boolean, message: String.t()}
end

defmodule ShortenApi.Plug.REST do
  @moduledoc """
  A REST Plug for generating short links.
  """
  @behaviour Plug
  import Plug.Conn

  @doc """
  Pass `Plug.opts` to `call/2`
  """
  @spec init(Plug.opts()) :: Plug.opts()
  def init(opts), do: opts

  @doc """
  Process `Plug.Conn.t`, return the generated short link.
  """
  @spec call(Plug.Conn.t(), Plug.opts()) :: Plug.Conn.t()
  def call(conn, _opts) do
    resp_msg =
      with {:ok, url} <- Map.fetch(conn.params, "url"),
           {:ok, hash} <- ShortenApi.HashId.generate(url) do
        ShortenApi.DB.Link.write(hash, url)
      end

    conn
    |> put_resp_content_type("application/json")
    |> put_resp_msg(resp_msg)
    |> send_resp()
  end

  @doc false
  @spec put_resp_msg(
          Plug.Conn.t(),
          :error | {:error, Ecto.Changeset.t()} | {:ok, Ecto.Schema.t()}
        ) :: Plug.Conn.t()
  def put_resp_msg(conn, {:ok, struct}) do
    alias ShortenApi.Plug.REST.Resp
    [host_url | _tail] = get_req_header(conn, "host")
    short_link = "#{conn.scheme}://#{host_url}/#{struct.hash}"
    resp_json = Jason.encode!(%Resp{short_link: short_link})
    resp(conn, 201, resp_json)
  end

  def put_resp_msg(conn, {:error, _changeset}) do
    alias ShortenApi.Plug.REST.ErrResp
    resp_json = Jason.encode!(%ErrResp{message: "Wrong format"})
    resp(conn, 403, resp_json)
  end

  def put_resp_msg(conn, :error) do
    alias ShortenApi.Plug.REST.ErrResp
    resp_json = Jason.encode!(%ErrResp{message: "Parameter error"})
    resp(conn, 404, resp_json)
  end
end
