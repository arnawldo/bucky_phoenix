defmodule BuckyPhoenixWeb.ListController do
  use BuckyPhoenixWeb, :controller

  alias BuckyPhoenix.Todo
  alias BuckyPhoenix.Todo.List
  alias BuckyPhoenixWeb.Auth

  import BuckyPhoenixWeb.Auth

  plug :authenticate_user

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) do
    lists = Todo.list_user_lists(current_user)
    render(conn, "index.html", lists: lists)
  end

  def new(conn, _params, _current_user) do
    changeset = Todo.change_list(%List{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"list" => list_params}, current_user) do
    case Todo.create_user_list(current_user, list_params) do
      {:ok, list} ->
        conn
        |> put_flash(:info, "List created successfully.")
        |> redirect(to: Routes.list_path(conn, :show, list))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    list = Todo.get_user_list!(current_user, id)
    render(conn, "show.html", list: list)
  end

  def edit(conn, %{"id" => id}, current_user) do
    list = Todo.get_user_list!(current_user, id)
    changeset = Todo.change_list(list)
    render(conn, "edit.html", list: list, changeset: changeset)
  end

  def update(conn, %{"id" => id, "list" => list_params}, current_user) do
    list = Todo.get_user_list!(current_user, id)

    case Todo.update_list(list, list_params) do
      {:ok, list} ->
        conn
        |> put_flash(:info, "List updated successfully.")
        |> redirect(to: Routes.list_path(conn, :show, list))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", list: list, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    list = Todo.get_user_list!(current_user, id)
    {:ok, _list} = Todo.delete_list(list)

    conn
    |> put_flash(:info, "List deleted successfully.")
    |> redirect(to: Routes.list_path(conn, :index))
  end
end
