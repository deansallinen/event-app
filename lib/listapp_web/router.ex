defmodule ListappWeb.Router do
  use ListappWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ListappWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ListappWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/events/:id", EventController, :show

    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete], singleton: true
  end


  scope "/manage", ListappWeb do
    pipe_through [:browser, :authenticate_user]
    resources "/events", EventController do
      resources "/items", ItemController
      put "/items/:id/claim", ItemController, :claim
      resources "/guests", GuestController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ListappWeb do
  #   pipe_through :api
  # end

end
