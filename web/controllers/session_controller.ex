defmodule Asapp.SessionController do
    use Asapp.Web, :controller

    def new(conn, _) do
        render conn, "new.html"
    end

    def create(conn, %{"session" => %{"displayname" => user, "password" => pass}}) do
        case Asapp.Auth.login_by_displayname_and_pass(conn, user, pass, repo: Repo) do
            {:ok, conn} ->
                conn
                |> put_flash(:info, "Welcome back!")
                |> redirect(to: page_path(conn, :index))
            {:error, _reason, conn} ->
                conn
                |> put_flash(:error, "Invalid displayname/password combination")
                |> render("new.html")
        end
    end

    def delete(conn, _) do
        conn
        |> Asapp.Auth.logout()
        |> put_flash(:info, "You have been logged out.")
        |> redirect(to: page_path(conn, :index))
    end
end
