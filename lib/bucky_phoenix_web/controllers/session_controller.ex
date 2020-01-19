defmodule BuckyPhoenixWeb.SessionController do
  use BuckyPhoenixWeb, :controller

  alias BuckyPhoenix.Accounts
  alias BuckyPhoenixWeb.Router.Helpers, as: Routes

  import BuckyPhoenixWeb.Auth

  plug :authenticate_user when action in [:delete]

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_by_email_password(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> assign(:current_user, user)
        |> put_flash(:info, "Welcome back #{user.name}!")
        |> configure_session(renew: true)
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Bad email/password combination")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
