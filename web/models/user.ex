defmodule Asapp.User do
    use Asapp.Web, :model

    schema "users" do
        field :name, :string
        field :displayname, :string
        field :password, :string, virtual: true
        field :password_hash, :string

        timestamps
    end

    def changeset(model, params \\ :empty) do
        model
        |> cast(params, ~w(name displayname), [])
        |> validate_length(:displayname, min: 3, max: 20)
    end
end
