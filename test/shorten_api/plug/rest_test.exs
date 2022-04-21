defmodule ShortenApi.Plug.RESTTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias ShortenApi.Plug.REST

  @example_hash "dA5zl5B8"
  @example_body %{ok: true, short_link: "http://www.example.com/#{@example_hash}"}
  @example_error_msg %{ok: false, message: "Parameter error"}

  setup_all do
    get_conn =
      :get
      |> conn("/")
      |> put_req_header("host", "www.example.com")

    {:ok, get: get_conn}
  end

  test "put short link msg to resp", %{get: get_conn} do
    conn = REST.put_resp_msg(get_conn, {:ok, @example_hash})

    assert conn.state == :set
    assert conn.status == 201
    assert conn.resp_body == Jason.encode!(@example_body)
  end

  test "should put error msg to resp", %{get: get_conn} do
    conn = REST.put_resp_msg(get_conn, :error)

    assert conn.state == :set
    assert conn.status == 404
    assert conn.resp_body == Jason.encode!(@example_error_msg)
  end
end
