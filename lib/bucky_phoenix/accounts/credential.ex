defmodule BuckyPhoenix.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias BuckyPhoenix.Accounts.User

  schema "credentials" do
    field :email, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> unique_constraint(:email)
  end

  def changeset_with_user(credential, %User{} = user, attrs) do
    changeset(credential, attrs)
    |> put_assoc(:user, user)
  end
end
