defmodule BuckyPhoenix.Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias BuckyPhoenix.Todo.List

  schema "tasks" do
    field :name, :string
    belongs_to :list, List

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
