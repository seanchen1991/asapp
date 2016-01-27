defmodule Asapp.ChatroomTest do
  use Asapp.ModelCase

  alias Asapp.Chatroom

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Chatroom.changeset(%Chatroom{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Chatroom.changeset(%Chatroom{}, @invalid_attrs)
    refute changeset.valid?
  end
end
