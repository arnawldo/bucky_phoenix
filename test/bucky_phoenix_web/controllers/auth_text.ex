defmodule BuckyPhoenixWeb.AuthTest do
  use BuckyPhoenixWeb.ConnCase
  alias BuckyPhoenixWeb.Auth

  test "login puts the user in the session", %{conn: conn} do
    login_conn =
      conn
      |> Auth.login(%BuckyPhoenix.Accounts.User{id: 123})
      |> send_resp(:ok, "")

    next_conn = get(login_conn, "/")
    assert get_session(next_conn, :user_id) == 123
  end
end
