defmodule TransWeb.Router do
  use TransWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug TransWeb.Plugs.PutUserToken
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TransWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/home", PageController, :home
    get "/chats/:name", PageController, :chat
    post "/chats", PageController, :join
    resources "/rooms", RoomController
  end

  # Other scopes may use custom stacks.
  # scope "/api", TransWeb do
  #   pipe_through :api
  # end
end
