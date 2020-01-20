defmodule BuckyPhoenix.TestHelpers do
  alias BuckyPhoenix.Accounts
  alias BuckyPhoenix.Todo

  @valid_user_attrs %{
    name: "some name",
    username: "some username",
    password: "some password",
    credential: %{email: "some email"}
  }

  @valid_list_attrs %{name: "some name"}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_user_attrs)
      |> Accounts.create_user()

    # to preload credentials
    Accounts.get_user!(user.id)
  end

  def list_fixture(%Accounts.User{} = user, attrs \\ %{}) do
    attrs = Enum.into(attrs, @valid_list_attrs)
    {:ok, list} = Todo.create_user_list(user, attrs)

    list
  end
end
