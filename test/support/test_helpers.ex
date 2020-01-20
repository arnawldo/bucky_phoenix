defmodule BuckyPhoenix.TestHelpers do
  alias BuckyPhoenix.Accounts

  @valid_user_attrs %{
    name: "some name",
    username: "some username",
    password: "some password",
    credential: %{email: "some email"}
  }

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_user_attrs)
      |> Accounts.create_user()

    # to preload credentials
    Accounts.get_user!(user.id)
  end
end
