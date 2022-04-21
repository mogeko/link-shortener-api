defmodule ShortenApi.Plug.RESTTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias ShortenApi.Plug.REST

  @example_hash "dA5zl5B8"
  @example_body %REST.Resp{short_link: "http://www.example.com/#{@example_hash}"}
  @example_error_msg %REST.ErrResp{message: "Parameter error"}

  setup_all do
    get_conn =
      :get
      |> conn("/")
      |> put_req_header("host", "www.example.com")

    struct = %ShortenApi.DB.Link{hash: @example_hash}

    {:ok, conn: get_conn, struct: struct}
  end

  test "put short link msg to resp", %{conn: get_conn, struct: struct} do
    conn = REST.put_resp_msg(get_conn, {:ok, struct})

    assert conn.state == :set
    assert conn.status == 201
    assert conn.resp_body == Jason.encode!(@example_body)
  end

  test "should put error msg to resp", %{conn: get_conn} do
    conn = REST.put_resp_msg(get_conn, :error)

    assert conn.state == :set
    assert conn.status == 404
    assert conn.resp_body == Jason.encode!(@example_error_msg)
  end
end
