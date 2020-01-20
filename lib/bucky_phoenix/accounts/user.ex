defmodule BuckyPhoenix.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias BuckyPhoenix.Accounts.Credential

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string

    has_one :credential, Credential

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :password])
    |> validate_required([:name, :username, :password])
    |> unique_constraint(:username)
  end
end
