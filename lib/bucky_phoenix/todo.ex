defmodule BuckyPhoenix.Todo do
  @moduledoc """
  The Todo context.
  """

  import Ecto.Query, warn: false
  alias BuckyPhoenix.Repo

  alias BuckyPhoenix.Todo.List
  alias BuckyPhoenix.Accounts.User

  @doc """
  Returns the list of user lists.

  ## Examples

      iex> list_user_lists(%User{})
      [%List{}, ...]

  """
  def list_user_lists(%User{} = user) do
    List
    |> user_scoped_query(user)
    |> Repo.all()
  end

  @doc """
  Gets a single list owned by user.

  Raises `Ecto.NoResultsError` if the List does not exist.

  ## Examples

      iex> get_user_list!(%User{}, 123)
      %List{}

      iex> get_user_list!(%User{}, 456)
      ** (Ecto.NoResultsError)

  """
  def get_user_list!(%User{} = user, id) do
    List
    |> user_scoped_query(user)
    |> where(id: ^id)
    |> Repo.one!()
    |> Repo.preload(:user)
  end

  @doc """
  Creates a list.

  ## Examples

      iex> create_list(%{field: value})
      {:ok, %List{}}

      iex> create_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_list(%User{} = user, attrs \\ %{}) do
    %List{}
    |> List.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a list.

  ## Examples

      iex> update_list(list, %{field: new_value})
      {:ok, %List{}}

      iex> update_list(list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_list(%List{} = list, attrs) do
    list
    |> List.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a List.

  ## Examples

      iex> delete_list(list)
      {:ok, %List{}}

      iex> delete_list(list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list(%List{} = list) do
    Repo.delete(list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list changes.

  ## Examples

      iex> change_list(list)
      %Ecto.Changeset{source: %List{}}

  """
  def change_list(%List{} = list) do
    List.changeset(list, %{})
  end

  defp user_scoped_query(query, %User{id: user_id}) do
    from l in query, where: l.user_id == ^user_id
  end
end
