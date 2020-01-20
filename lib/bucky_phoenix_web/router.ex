defmodule BuckyPhoenixWeb.Router do
  use BuckyPhoenixWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BuckyPhoenixWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BuckyPhoenixWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/users", UserController
    resources "/lists", ListController

    resources "/sessions", SessionController,
      only: [:new, :create, :delete],
      singleton: true
  end

  # Other scopes may use custom stacks.
  # scope "/api", BuckyPhoenixWeb do
  #   pipe_through :api
  # end
end
