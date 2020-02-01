defmodule BuckyPhoenix.Repo.Migrations.MovePasswordFromCredentialToUser do
  use Ecto.Migration
  alias BuckyPhoenix.Accounts

  def up do
    Accounts.list_users()
    |> Enum.map(&Accounts.update_user(&1, %{password: &1.credential.password}))

    alter table("credentials") do
      remove :password
    end
  end

  def down do
    alter table("credentials") do
      add :password, :string
    end

    Accounts.list_users()
    |> Enum.map(&Accounts.update_credential(&1, %{password: &1.user.password}))
  end
end
