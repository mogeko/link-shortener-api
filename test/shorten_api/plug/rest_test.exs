defmodule ShortenApi.Plug.RESTTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias ShortenApi.Plug.REST

  @example_url "http://www.example.com"
  @example_hash "dA5zl5B8"
  @example_body %REST.Resp{short_link: "#{@example_url}/#{@example_hash}"}

  setup_all do
    get_conn =
      :get
      |> conn("/")
      |> put_req_header("host", "www.example.com")

    alias ShortenApi.DB.Link
    struct = %Link{hash: @example_hash}
    changeset = Link.changeset(%Link{}, %{url: @example_url})

    {:ok, conn: get_conn, struct: struct, changeset: changeset}
  end

  test "put short link msg to resp", %{conn: get_conn, struct: struct} do
    conn = REST.put_resp_msg(get_conn, {:ok, struct})

    assert conn.state == :set
    assert conn.status == 201
    assert conn.resp_body == Jason.encode!(@example_body)
  end

  test "should put error msg_404 to resp", %{conn: get_conn} do
    err_msg = %REST.ErrResp{message: "Parameter error"}
    conn = REST.put_resp_msg(get_conn, :error)

    assert conn.state == :set
    assert conn.status == 404
    assert conn.resp_body == Jason.encode!(err_msg)
  end

  test "should put error msg_403 to resp", %{conn: get_conn, changeset: changeset} do
    err_msg = %REST.ErrResp{message: "Wrong format"}
    conn = REST.put_resp_msg(get_conn, {:error, changeset})

    assert conn.state == :set
    assert conn.status == 403
    assert conn.resp_body == Jason.encode!(err_msg)
  end
end
