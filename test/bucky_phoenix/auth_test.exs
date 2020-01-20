defmodule BuckyPhoenixWeb.AuthTest do
  use BuckyPhoenixWeb.ConnCase, async: true
  alias BuckyPhoenixWeb.Auth
  alias BuckyPhoenix.Accounts.User
  import Plug.Conn

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(BuckyPhoenixWeb.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  test "authenticate_user halts conn when current_user is absent", %{conn: conn} do
    conn = Auth.authenticate_user(conn, [])

    assert conn.halted
    assert redirected_to(conn) =~ "/"
  end

  test "authenticate_user allows conn when current_user is present", %{conn: conn} do
    conn
    |> assign(:current_user, %User{})
    |> Auth.authenticate_user([])

    refute conn.halted
  end

  test "call assigns correct user to conn when user_id in session", %{conn: conn} do
    %User{id: user_id} = user_fixture()

    conn =
      conn
      |> put_session(:user_id, user_id)
      |> Auth.call([])

    assert %User{id: ^user_id} = conn.assigns.current_user
  end

  test "call assigns nil as currect_user to conn when user_id not in session", %{conn: conn} do
    conn = Auth.call(conn, [])

    refute conn.assigns.current_user
  end
end
