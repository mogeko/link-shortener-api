defmodule ShortenApi.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias ShortenApi.Router

  @example_url "https://www.example.com"
  @example_body %{ok: true, short_link: "http://www.example.com/dA5zl5B8"}
  @example_error_msg %{ok: false, message: "Parameter error"}

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
    conn = :get
    |> conn("/missing")
    |> Router.call(opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "return short url via GET", %{opts: opts} do
    conn = :get
    |> conn("/api/v1?url=#{@example_url}")
    |> put_req_header("host", "www.example.com")
    |> Router.call(opts)

    assert conn.state == :sent
    assert conn.status == 201
    assert conn.resp_body == Jason.encode!(@example_body)
  end

  test "return short url via POST", %{opts: opts} do
    conn = :post
    |> conn("/api/v1", %{url: @example_url})
    |> put_req_header("host", "www.example.com")
    |> Router.call(opts)

    assert conn.state == :sent
    assert conn.status == 201
    assert conn.resp_body == Jason.encode!(@example_body)
  end

  test "return error message", %{opts: opts} do
    conn = :get
    |> conn("/api/v1")
    |> put_req_header("host", "www.example.com")
    |> Router.call(opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == Jason.encode!(@example_error_msg)
  end


end
