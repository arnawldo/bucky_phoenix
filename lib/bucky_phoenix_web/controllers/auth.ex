defmodule BuckyPhoenixWeb.Auth do
  import Plug.Conn
  alias BuckyPhoenix.Accounts

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    cond do
      conn.assigns[:current_user] ->
        conn

      user_id = get_session(conn, :user_id) ->
        user = Accounts.get_user!(user_id)
        assign(conn, :current_user, user)

      true ->
        assign(conn, :current_user, nil)
    end
  end

  def authenticate_user(conn, _) do
    case conn.assigns[:current_user] do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()

      _ ->
        conn
    end
  end
end
