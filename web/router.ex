defmodule Asapp.Router do
  use Asapp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Asapp.Auth, repo: Asapp.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Asapp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/manage", Asapp do
      pipe_through [:browser, :authenticate_user]

      resources "/chatrooms", ChatroomController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Asapp do
  #   pipe_through :api
  # end
end
