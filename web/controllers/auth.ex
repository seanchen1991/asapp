defmodule Asapp.Auth do
    import Plug.Conn
    import Phoenix.Controller
    import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

    alias Asapp.Router.Helpers

    def init(opts) do
        Keyword.fetch!(opts, :repo)
    end

    def call(conn, repo) do
        user_id = get_session(conn, :user_id)

        cond do
            user = conn.assigns[:current_user] ->
                assign(conn, :current_user, user)
            user = user_id && repo.get(Asapp.User, user_id) ->
                assign(conn, :current_user, user)
            true ->
                assign(conn, :current_user, nil)
        end
    end

    def login(conn, user) do
        conn
        |> assign(:current_user, user)
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
    end

    def login_by_displayname_and_pass(conn, displayname, given_pass, opts) do
        repo = Keyword.fetch!(opts, :repo)
        user = repo.get_by(Asapp.User, displayname: displayname)

        cond do
            user && checkpw(given_pass, user.password_hash) ->
                {:ok, login(conn, user)}
            user ->
                {:error, :unauthorized, conn}
            true ->
                dummy_checkpw()
                {:error, :not_found, conn}
        end
    end

    def logout(conn) do
        configure_session(conn, drop: true)
    end

    def authenticate_user(conn, _opts) do
        if conn.assigns.current_user do
            conn
        else
            conn
            |> put_flash(:error, "You must be logged in to access that page.")
            |> redirect(to: Helpers.page_path(conn, :index))
            |> halt()
        end
    end
end
