defmodule Asapp.User do
    use Asapp.Web, :model

    schema "users" do
        field :name, :string
        field :displayname, :string
        field :password, :string, virtual: true
        field :password_hash, :string
        has_many :chatrooms, Asapp.Chatroom

        timestamps
    end

    def changeset(model, params \\ :empty) do
        model
        |> cast(params, ~w(name displayname), [])
        |> validate_length(:displayname, min: 3, max: 20)
        |> unique_constraint(:displayname)
    end

    def registration_changeset(model, params) do
        model
        |> changeset(params)
        |> cast(params, ~w(password), [])
        |> validate_length(:password, min: 6, max: 100)
        |> put_pass_hash()
    end

    defp put_pass_hash(changeset) do
        case changeset do
            %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
                put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
            _ ->
                changeset
        end
    end
end
