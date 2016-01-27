defmodule Asapp.Repo.Migrations.CreateChatroom do
    use Ecto.Migration

    def change do
        create table(:chatrooms) do
        add :name, :string
        add :user_id, references(:users, on_delete: :nothing)

        timestamps
    end
    create index(:chatrooms, [:user_id])

    end
end
