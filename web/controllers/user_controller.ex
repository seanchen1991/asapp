defmodule Asapp.UserController do
    use Asapp.Web, :controller

    def index(conn, _params) do
        users = Repo.all(Asapp.User)
        render conn, "index.html", users: users
    end

    def show(conn, %{"id" => id}) do
        user = Repo.get(Asapp.User, id)
        render conn, "show.html", user: user
    end
end
