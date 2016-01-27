defmodule Asapp.TestHelpers do
    alias Asapp.Repo

    def insert_user(attrs \\ %{}) do
        changes = Dict.merge(%{
            name: "Some User",
            displayname: "user#{Base.encode16(:crypto.rand_bytes(8))}",
            password: "supersecret"
        }, attrs)

        %Asapp.User{}
        |> Asapp.User.registration_changeset(changes)
        |> Repo.insert!()
    end

    def insert_chatroom(user, attrs \\ %{}) do
        user
        |> Ecto.build_assoc(:chatrooms, attrs)
        |> Repo.insert!()
    end
end
