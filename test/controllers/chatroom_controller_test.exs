defmodule Asapp.ChatroomControllerTest do
  use Asapp.ConnCase

  alias Asapp.Chatroom
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, chatroom_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing chatrooms"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, chatroom_path(conn, :new)
    assert html_response(conn, 200) =~ "New chatroom"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, chatroom_path(conn, :create), chatroom: @valid_attrs
    assert redirected_to(conn) == chatroom_path(conn, :index)
    assert Repo.get_by(Chatroom, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, chatroom_path(conn, :create), chatroom: @invalid_attrs
    assert html_response(conn, 200) =~ "New chatroom"
  end

  test "shows chosen resource", %{conn: conn} do
    chatroom = Repo.insert! %Chatroom{}
    conn = get conn, chatroom_path(conn, :show, chatroom)
    assert html_response(conn, 200) =~ "Show chatroom"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, chatroom_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    chatroom = Repo.insert! %Chatroom{}
    conn = get conn, chatroom_path(conn, :edit, chatroom)
    assert html_response(conn, 200) =~ "Edit chatroom"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    chatroom = Repo.insert! %Chatroom{}
    conn = put conn, chatroom_path(conn, :update, chatroom), chatroom: @valid_attrs
    assert redirected_to(conn) == chatroom_path(conn, :show, chatroom)
    assert Repo.get_by(Chatroom, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    chatroom = Repo.insert! %Chatroom{}
    conn = put conn, chatroom_path(conn, :update, chatroom), chatroom: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit chatroom"
  end

  test "deletes chosen resource", %{conn: conn} do
    chatroom = Repo.insert! %Chatroom{}
    conn = delete conn, chatroom_path(conn, :delete, chatroom)
    assert redirected_to(conn) == chatroom_path(conn, :index)
    refute Repo.get(Chatroom, chatroom.id)
  end
end
