defmodule BuckyPhoenixWeb.ListControllerTest do
  use BuckyPhoenixWeb.ConnCase

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}
  @other_list_attrs %{name: "some other list name"}
  @other_user_attrs %{
    name: "some other name",
    username: "some other username",
    password: "some other password",
    credential: %{email: "some other email"}
  }

  setup %{conn: conn} do
    user = user_fixture()
    conn = assign(conn, :current_user, user)
    {:ok, conn: conn, user: user}
  end

  describe "index" do
    test "lists all user lists", %{conn: conn, user: user} do
      list = list_fixture(user)
      other_user_list = list_fixture(user_fixture(@other_user_attrs), @other_list_attrs)

      conn = get(conn, Routes.list_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Lists"
      assert String.contains?(conn.resp_body, list.name)
      refute String.contains?(conn.resp_body, other_user_list.name)
    end
  end

  describe "new list" do
    test "renders form", %{conn: conn, user: _user} do
      conn = get(conn, Routes.list_path(conn, :new))
      assert html_response(conn, 200) =~ "New List"
    end
  end

  describe "create list" do
    test "redirects to show when data is valid", %{conn: conn, user: _user} do
      create_conn = post(conn, Routes.list_path(conn, :create), list: @create_attrs)

      assert %{id: id} = redirected_params(create_conn)
      assert redirected_to(create_conn) == Routes.list_path(create_conn, :show, id)

      show_conn = get(conn, Routes.list_path(conn, :show, id))
      assert html_response(show_conn, 200) =~ "Show List"
    end

    test "renders errors when data is invalid", %{conn: conn, user: _user} do
      conn = post(conn, Routes.list_path(conn, :create), list: @invalid_attrs)
      assert html_response(conn, 200) =~ "New List"
    end
  end

  describe "edit list" do
    test "renders form for editing chosen list", %{conn: conn, user: user} do
      list = list_fixture(user)

      conn = get(conn, Routes.list_path(conn, :edit, list))
      assert html_response(conn, 200) =~ "Edit List"
    end
  end

  describe "update list" do
    test "redirects when data is valid", %{conn: conn, user: user} do
      list = list_fixture(user)

      update_conn = put(conn, Routes.list_path(conn, :update, list), list: @update_attrs)

      assert redirected_to(update_conn) == Routes.list_path(update_conn, :show, list)

      show_conn = get(conn, Routes.list_path(conn, :show, list))
      assert html_response(show_conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      list = list_fixture(user)

      conn = put(conn, Routes.list_path(conn, :update, list), list: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit List"
    end
  end

  describe "delete list" do
    test "deletes chosen list", %{conn: conn, user: user} do
      list = list_fixture(user)

      delete_conn = delete(conn, Routes.list_path(conn, :delete, list))
      assert redirected_to(delete_conn) == Routes.list_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.list_path(conn, :show, list))
      end
    end
  end
end
