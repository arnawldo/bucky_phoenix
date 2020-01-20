defmodule BuckyPhoenix.Todo.List do
  use Ecto.Schema
  import Ecto.Changeset
  alias BuckyPhoenix.Accounts.User

  schema "lists" do
    field :name, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
