defmodule Asapp.User do
    use Asapp.Web, :model

    schema "users" do
        field :name, :string
        field :displayname, :string
        field :password, :string, virtual: true
        field :password_hash, :string

        timestamps
    end
end
