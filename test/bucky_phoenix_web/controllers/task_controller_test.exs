defmodule BuckyPhoenixWeb.TaskControllerTest do
  use BuckyPhoenixWeb.ConnCase

  alias BuckyPhoenix.Todo

  @create_attrs %{name: "some task name"}
  @update_attrs %{name: "some updated task name"}
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    user = user_fixture()
    list = list_fixture(user)

    conn = assign(conn, :current_user, user)
    {:ok, conn: conn, user: user, list: list}
  end

  describe "index" do
    test "lists all tasks", %{conn: conn, list: list} do
      conn = get(conn, Routes.list_task_path(conn, :index, list))
      assert html_response(conn, 200) =~ list.name
    end
  end

  describe "new task" do
    test "renders form", %{conn: conn, list: list} do
      conn = get(conn, Routes.list_task_path(conn, :new, list))
      assert html_response(conn, 200) =~ "New Task"
    end
  end

  describe "create task" do
    test "redirects to show when data is valid", %{conn: conn, list: list} do
      create_conn = post(conn, Routes.list_task_path(conn, :create, list), task: @create_attrs)

      assert %{id: id} = redirected_params(create_conn)
      assert redirected_to(create_conn) == Routes.list_task_path(create_conn, :show, list, id)

      show_conn = get(conn, Routes.list_task_path(conn, :show, list, id))
      assert html_response(show_conn, 200) =~ "Show Task"
    end

    test "renders errors when data is invalid", %{conn: conn, list: list} do
      conn = post(conn, Routes.list_task_path(conn, :create, list), task: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Task"
    end
  end

  describe "edit task" do
    setup :create_task

    test "renders form for editing chosen task", %{conn: conn, list: list, task: task} do
      conn = get(conn, Routes.list_task_path(conn, :edit, list, task))
      assert html_response(conn, 200) =~ "Edit Task"
    end
  end

  describe "update task" do
    setup :create_task

    test "redirects when data is valid", %{conn: conn, list: list, task: task} do
      update_conn =
        put(conn, Routes.list_task_path(conn, :update, list, task), task: @update_attrs)

      assert redirected_to(update_conn) == Routes.list_task_path(conn, :show, list, task)

      show_conn = get(conn, Routes.list_task_path(conn, :show, list, task))
      assert html_response(show_conn, 200) =~ "some updated task name"
    end

    test "renders errors when data is invalid", %{conn: conn, list: list, task: task} do
      conn = put(conn, Routes.list_task_path(conn, :update, list, task), task: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Task"
    end
  end

  describe "delete task" do
    setup :create_task

    test "deletes chosen task", %{conn: conn, list: list, task: task} do
      delete_conn = delete(conn, Routes.list_task_path(conn, :delete, list, task))
      assert redirected_to(delete_conn) == Routes.list_task_path(conn, :index, list)

      assert_error_sent 404, fn ->
        get(conn, Routes.list_task_path(conn, :show, list, task))
      end
    end
  end

  defp create_task(%{list: list} = context) do
    task = task_fixture(list)
    Map.put(context, :task, task)
  end
end
