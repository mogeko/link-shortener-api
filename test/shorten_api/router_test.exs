defmodule ShortenApi.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias ShortenApi.Router

  setup_all do
    opts = Router.init([])
    {:ok, opts: opts}
  end

  test "returns welcome message", %{opts: opts} do
    conn =
      :get
      |> conn("/")
      |> put_req_header("host", "www.example.com")
      |> Router.call(opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "returns 404", %{opts: opts} do
    conn =
      :get
      |> conn("/missing")
      |> Router.call(opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "return 403 from /api/v1", %{opts: opts} do
    conn =
      :get
      |> conn("/api/v1?url=www.example.com")
      |> put_req_header("host", "www.example.com")
      |> Router.call(opts)

    assert conn.state == :sent
    assert conn.status == 403
  end
end
