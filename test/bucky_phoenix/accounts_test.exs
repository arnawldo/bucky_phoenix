defmodule BuckyPhoenix.AccountsTest do
  use BuckyPhoenix.DataCase, async: true

  alias BuckyPhoenix.Accounts

  describe "users" do
    alias BuckyPhoenix.Accounts.User

    @valid_attrs %{
      name: "some name",
      username: "some username",
      password: "some password",
      credential: %{email: "some email"}
    }
    @update_attrs %{
      name: "some updated name",
      username: "some updated username",
      password: "some updated password"
    }
    @invalid_attrs %{name: nil, username: nil, password: nil, credential: %{email: nil}}

    test "list_users/0 returns all users" do
      %User{id: id} = user_fixture()
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "get_user!/1 returns the user with given id" do
      %User{id: id} = user_fixture()
      assert %User{id: ^id} = Accounts.get_user!(id)
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.name == @valid_attrs[:name]
      assert user.username == @valid_attrs[:username]
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, changeset} = Accounts.create_user(@invalid_attrs)

      assert %{
               credential: %{email: ["can't be blank"]},
               name: ["can't be blank"],
               password: ["can't be blank"],
               username: ["can't be blank"]
             } = errors_on(changeset)

      assert [] == Accounts.list_users()
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      # Update of nested entity needs primary therefore creating resources then building updated attrs
      update_attrs =
        Enum.into(
          %{credential: %{id: user.credential.id, email: "some updated email"}},
          @update_attrs
        )

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.name == update_attrs[:name]
      assert user.username == update_attrs[:username]
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()

      # Update of nested entity needs primary therefore creating resources then building updated attrs
      invalid_attrs =
        Enum.into(%{credential: %{id: user.credential.id, email: nil}}, @invalid_attrs)

      assert {:error, changeset} = Accounts.update_user(user, invalid_attrs)

      assert %{
               name: ["can't be blank"],
               password: ["can't be blank"],
               username: ["can't be blank"],
               credential: %{email: ["can't be blank"]}
             } = errors_on(changeset)

      user = Accounts.get_user!(user.id)
      assert user.name != invalid_attrs[:name]
      assert user.username != invalid_attrs[:username]
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
