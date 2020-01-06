defmodule ListappWeb.Router do
  use ListappWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
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
    get "/design", PageController, :design

    resources "/events", EventController, only: [:show, :index] 
    # get "/events/:id", EventController, :show
    get "/items", ItemController, :live

    resources "/users", UserController, only: [:new, :create, :show]
    get "/login", SessionController, :new
    delete "/logout", SessionController, :delete
    resources "/sessions", SessionController, only: [:create], singleton: true
  end


  scope "/manage", ListappWeb do
    pipe_through [:browser, :authenticate_user]

    resources "/events", EventController do
      resources "/items", ItemController
      put "/items/:id/claim", ItemController, :claim
      resources "/guests", GuestController
      resources "/comments", CommentController
    end
  end

  scope "/admin", ListappWeb do
    pipe_through [:browser, :authenticate_user]

    resources "/users", UserController, except: [:new, :create] 
  end

  # Other scopes may use custom stacks.
  # scope "/api", ListappWeb do
  #   pipe_through :api
  # end

end
