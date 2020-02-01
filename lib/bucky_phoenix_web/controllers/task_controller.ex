defmodule BuckyPhoenixWeb.TaskController do
  use BuckyPhoenixWeb, :controller

  alias BuckyPhoenix.Todo
  alias BuckyPhoenix.Todo.Task

  import BuckyPhoenixWeb.Auth

  plug :authenticate_user

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, %{"list_id" => list_id}, current_user) do
    list = Todo.get_user_list!(current_user, list_id)
    tasks = Todo.list_tasks(list)
    render(conn, "index.html", tasks: tasks, list: list)
  end

  def new(conn, %{"list_id" => list_id}, current_user) do
    list = Todo.get_user_list!(current_user, list_id)
    changeset = Todo.change_task(%Task{})
    render(conn, "new.html", changeset: changeset, list: list)
  end

  def create(conn, %{"task" => task_params, "list_id" => list_id}, current_user) do
    list = Todo.get_user_list!(current_user, list_id)

    case Todo.create_task(list, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: Routes.list_task_path(conn, :show, list, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, list: list)
    end
  end

  def show(conn, %{"list_id" => list_id, "id" => id}, current_user) do
    list = Todo.get_user_list!(current_user, list_id)
    task = Todo.get_task!(list, id)

    render(conn, "show.html", task: task, list: list)
  end

  def edit(conn, %{"list_id" => list_id, "id" => id}, current_user) do
    list = Todo.get_user_list!(current_user, list_id)
    task = Todo.get_task!(list, id)
    changeset = Todo.change_task(task)

    render(conn, "edit.html", task: task, changeset: changeset, list: list)
  end

  def update(conn, %{"list_id" => list_id, "id" => id, "task" => task_params}, current_user) do
    list = Todo.get_user_list!(current_user, list_id)
    task = Todo.get_task!(list, id)

    case Todo.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.list_task_path(conn, :show, list, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, list: list, changeset: changeset)
    end
  end

  def delete(conn, %{"list_id" => list_id, "id" => id}, current_user) do
    list = Todo.get_user_list!(current_user, list_id)
    task = Todo.get_task!(list, id)
    {:ok, _task} = Todo.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: Routes.list_task_path(conn, :index, list))
  end
end
