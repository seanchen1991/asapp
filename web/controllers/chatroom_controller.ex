defmodule Asapp.ChatroomController do
  use Asapp.Web, :controller

  alias Asapp.Chatroom

  plug :scrub_params, "chatroom" when action in [:create, :update]

  def index(conn, _params) do
    chatrooms = Repo.all(Chatroom)
    render(conn, "index.html", chatrooms: chatrooms)
  end

  def new(conn, _params) do
    changeset = Chatroom.changeset(%Chatroom{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"chatroom" => chatroom_params}) do
    changeset = Chatroom.changeset(%Chatroom{}, chatroom_params)

    case Repo.insert(changeset) do
      {:ok, _chatroom} ->
        conn
        |> put_flash(:info, "Chatroom created successfully.")
        |> redirect(to: chatroom_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    chatroom = Repo.get!(Chatroom, id)
    render(conn, "show.html", chatroom: chatroom)
  end

  def edit(conn, %{"id" => id}) do
    chatroom = Repo.get!(Chatroom, id)
    changeset = Chatroom.changeset(chatroom)
    render(conn, "edit.html", chatroom: chatroom, changeset: changeset)
  end

  def update(conn, %{"id" => id, "chatroom" => chatroom_params}) do
    chatroom = Repo.get!(Chatroom, id)
    changeset = Chatroom.changeset(chatroom, chatroom_params)

    case Repo.update(changeset) do
      {:ok, chatroom} ->
        conn
        |> put_flash(:info, "Chatroom updated successfully.")
        |> redirect(to: chatroom_path(conn, :show, chatroom))
      {:error, changeset} ->
        render(conn, "edit.html", chatroom: chatroom, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    chatroom = Repo.get!(Chatroom, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(chatroom)

    conn
    |> put_flash(:info, "Chatroom deleted successfully.")
    |> redirect(to: chatroom_path(conn, :index))
  end
end
