defmodule Asapp.UserView do
    use Asapp.Web, :view
    alias Asapp.User

    def first_name(%User{name: name}) do
        name
        |> String.split(" ")
        |> Enum.at(0)
    end
end
