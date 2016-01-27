defmodule Asapp.ChatroomControllerTest do
    use Asapp.ConnCase
    alias Asapp.Chatroom

    @valid_attrs %{name: "chatroom"}
    @invalid_attrs %{name: "invalid"}

    setup %{conn: conn} = config do
        if displayname = config[:login_as] do
            user = insert_user(displayname: displayname)
            conn = assign(conn(), :current_user, user)
            {:ok, conn: conn, user: user}
        else
            :ok
        end
    end

    defp chatroom_count(query), do: Repo.one(from c in query, select: count(c.id))

    @tag login_as: "max"
    test "creates user chatroom and redirects", %{conn: conn, user: user} do
        conn = post conn, chatroom_path(conn, :create), chatroom: @valid_attrs
        assert redirected_to(conn) == chatroom_path(conn, :index)
        assert Repo.get_by!(Chatroom, @valid_attrs).user_id == user.id
    end

    @tag login_as: "max"
    test "does not create chatroom and renders errors when invalid", %{conn: conn} do
        count_before = chatroom_count(Chatroom)
        conn = post conn, chatroom_path(conn, :create), chatroom: @invalid_attrs
        assert html_response(conn, 200) =~ "check the errors"
        assert chatroom_count(Chatroom) == count_before
    end

    @tag login_as: "max"
    test "authorizes actions against access by other users", %{user: owner, conn: conn} do
        chatroom = insert_chatroom(owner, @valid_attrs)
        non_owner = insert_user(displayname: "sneaky")
        conn = assign(conn, :current_user, non_owner)

        assert_error_sent :not_found, fn ->
            get(conn, chatroom_path(conn, :edit, chatroom))
        end
        assert_error_sent :not_found, fn ->
            put(conn, chatroom_path(conn, :update, chatroom, chatroom: @valid_attrs))
        end
        assert_error_sent :not_found, fn ->
            delete(conn, chatroom_path(conn, :delete, chatroom))
        end
    end

    test "lists all user's chatrooms on index", %{conn: conn, user: user} do
        user_chatroom = insert_chatroom(user, name: "funny cats")
        other_chatroom = insert_chatroom(insert_user(displayname: "other"), name: "another chatroom")

        conn = get conn, chatroom_path(conn, :index)
        assert html_response(conn, 200) =~ ~r/Listing chatrooms/
        assert String.contains?(conn.resp_body, user_chatroom.name)
        assert String.contains?(conn.resp_body, other_chatroom.name)
    end

    test "requires user authentication on all actions", %{conn: conn} do
        Enum.each([
            get(conn, chatroom_path(conn, :new)),
            get(conn, chatroom_path(conn, :index)),
            get(conn, chatroom_path(conn, :show, "123")),
            get(conn, chatroom_path(conn, :edit, "123")),
            put(conn, chatroom_path(conn, :update, "123", %{})),
            post(conn, chatroom_path(conn, :create, %{})),
            delete(conn, chatroom_path(conn, :delete, "123"))
        ], fn conn ->
            assert html_response(conn, 302)
            assert conn.halted
        end)
    end
end
