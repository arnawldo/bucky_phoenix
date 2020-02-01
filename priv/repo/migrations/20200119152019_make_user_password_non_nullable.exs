defmodule BuckyPhoenix.Repo.Migrations.MakeUserPasswordNonNullable do
  use Ecto.Migration

  def change do
    alter table("users") do
      modify :password, :string, default: "", null: false
    end
  end
end
