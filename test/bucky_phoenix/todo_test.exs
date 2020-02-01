defmodule BuckyPhoenix.TodoTest do
  use BuckyPhoenix.DataCase, async: true

  alias BuckyPhoenix.Todo

  describe "lists" do
    alias BuckyPhoenix.Todo.List
    alias BuckyPhoenix.Accounts.User

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}
    @other_user_attrs %{
      name: "some other name",
      username: "some other username",
      password: "some other password",
      credential: %{email: "some other email"}
    }

    setup do
      {:ok, %{user: user_fixture(), other_user: user_fixture(@other_user_attrs)}}
    end

    test "list_user_lists/1 returns all user lists", %{user: user, other_user: other_user} do
      %List{id: list_id} = list_fixture(user)
      _ = list_fixture(other_user)

      assert [%List{id: ^list_id}] = Todo.list_user_lists(user)
    end

    test "get_user_list!/2 returns the user's list with given id", %{
      user: user,
      other_user: other_user
    } do
      %List{id: list_id} = list_fixture(user)
      %List{id: other_user_list_id} = list_fixture(other_user)

      assert %List{id: list_id} = Todo.get_user_list!(user, list_id)
      assert_raise Ecto.NoResultsError, fn -> Todo.get_user_list!(user, other_user_list_id) end
    end

    test "create_user_list/1 with valid data creates a list", %{user: %User{id: user_id} = user} do
      assert {:ok, %List{} = list} = Todo.create_user_list(user, @valid_attrs)
      assert list.name == "some name"
      assert list.user_id == user_id
    end

    test "create_user_list/1 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Todo.create_user_list(user, @invalid_attrs)
    end

    test "update_list/2 with valid data updates the list", %{user: user} do
      list = list_fixture(user)
      assert {:ok, %List{} = list} = Todo.update_list(list, @update_attrs)
      assert list.name == "some updated name"
    end

    test "update_list/2 with invalid data returns error changeset", %{user: user} do
      %List{id: list_id} = list = list_fixture(user)
      assert {:error, %Ecto.Changeset{}} = Todo.update_list(list, @invalid_attrs)
      assert %List{id: ^list_id} = Todo.get_user_list!(user, list.id)
    end

    test "delete_list/1 deletes the list", %{user: user} do
      list = list_fixture(user)
      assert {:ok, %List{}} = Todo.delete_list(list)
      assert_raise Ecto.NoResultsError, fn -> Todo.get_user_list!(user, list.id) end
    end

    test "change_list/1 returns a list changeset", %{user: user} do
      list = list_fixture(user)
      assert %Ecto.Changeset{} = Todo.change_list(list)
    end
  end

  describe "tasks" do
    alias BuckyPhoenix.Todo.Task

    @valid_attrs %{name: "some task name"}
    @update_attrs %{name: "some updated task name"}
    @invalid_attrs %{name: nil}
    @other_user_attrs %{
      name: "some other name",
      username: "some other username",
      password: "some other password",
      credential: %{email: "some other email"}
    }

    setup do
      user = user_fixture()
      list = list_fixture(user)

      {:ok, %{user: user, list: list}}
    end

    test "list_tasks/1 returns all tasks in a list", %{list: list} do
      %Task{id: task_id} = task_fixture(list)
      assert [%Task{id: ^task_id}] = Todo.list_tasks(list)
    end

    test "create_task/1 with valid data creates a task", %{list: list} do
      assert {:ok, %Task{} = task} = Todo.create_task(list, @valid_attrs)
      assert task.name == "some task name"
    end

    test "create_task/1 with invalid data returns error changeset", %{list: list} do
      assert {:error, %Ecto.Changeset{}} = Todo.create_task(list, @invalid_attrs)
    end

    test "update_task/2 with valid data updates the task", %{list: list} do
      task = task_fixture(list)
      assert {:ok, %Task{} = task} = Todo.update_task(task, @update_attrs)
      assert task.name == "some updated task name"
    end

    test "update_task/2 with invalid data returns error changeset", %{list: list} do
      task = task_fixture(list)
      assert {:error, %Ecto.Changeset{}} = Todo.update_task(task, @invalid_attrs)
    end

    test "delete_task/1 deletes the task", %{list: list} do
      task = task_fixture(list)
      assert {:ok, %Task{}} = Todo.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Todo.get_task!(list, task.id) end
    end

    test "change_task/1 returns a task changeset", %{list: list} do
      task = task_fixture(list)
      assert %Ecto.Changeset{} = Todo.change_task(task)
    end
  end
end
