defmodule Asapp.ChatroomController do
    use Asapp.Web, :controller

    alias Asapp.Chatroom

    plug :scrub_params, "chatroom" when action in [:create, :update]

    def action(conn, _) do
      apply(__MODULE__, action_name(conn),
            [conn, conn.params, conn.assigns.current_user])
    end

    def index(conn, _params, _user) do
        chatrooms = Repo.all(Chatroom)
        render(conn, "index.html", chatrooms: chatrooms)
    end

    def new(conn, _params, user) do
        changeset =
            user
            |> build_assoc(:chatrooms)
            |> Chatroom.changeset()

        render(conn, "new.html", changeset: changeset)
    end

    def create(conn, %{"chatroom" => chatroom_params}, user) do
        changeset =
            user
            |> build_assoc(:chatrooms)
            |> Chatroom.changeset(chatroom_params)

        case Repo.insert(changeset) do
            {:ok, _chatroom} ->
                conn
                |> put_flash(:info, "Chatroom successfully created.")
                |> redirect(to: chatroom_path(conn, :index))
            {:error, changeset} ->
                render(conn, "new.html", changeset: changeset)
        end
    end

    def show(conn, %{"id" => id}, _user) do
        chatroom = Repo.get!(Chatroom, id)
        render(conn, "show.html", chatroom: chatroom)
    end

    def edit(conn, %{"id" => id}, user) do
        chatroom = Repo.get!(user_chatrooms(user), id)
        changeset = Chatroom.changeset(chatroom)
        render(conn, "edit.html", chatroom: chatroom, changeset: changeset)
    end

    def update(conn, %{"id" => id, "chatroom" => chatroom_params}, user) do
        chatroom = Repo.get!(user_chatrooms(user), id)
        changeset = Chatroom.changeset(chatroom, chatroom_params)

        case Repo.update(changeset) do
            {:ok, chatroom} ->
                conn
                |> put_flash(:info, "Chatroom successfully updated.")
                |> redirect(to: chatroom_path(conn, :show, chatroom))
            {:error, changeset} ->
                render(conn, "edit.html", chatroom: chatroom, changeset: changeset)
        end
    end

    def delete(conn, %{"id" => id}, user) do
        chatroom = Repo.get!(user_chatrooms(user), id)

        # Here we use delete! (with a bang) because we expect
        # it to always work (and if it does not, it will raise).
        Repo.delete!(chatroom)

        conn
        |> put_flash(:info, "Chatroom successfully deleted.")
        |> redirect(to: chatroom_path(conn, :index))
    end

    defp user_chatrooms(user) do
        assoc(user, :chatrooms)
    end
end
