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
end
