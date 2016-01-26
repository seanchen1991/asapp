defmodule Asapp.PageController do
  use Asapp.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
