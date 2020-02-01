defmodule BuckyPhoenixWeb.PageControllerTest do
  use BuckyPhoenixWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Bucky!"
  end
end
