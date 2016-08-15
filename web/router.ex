defmodule Store.Router do
  use Store.Web, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session  # Add this
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true    # Add this
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Add this block
  scope "/" do
    pipe_through :browser
    coherence_routes
  end

  # Add this block
  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end

  scope "/", Store do
    pipe_through :browser
    get "/", PageController, :index
    resources "/products", ProductController, only: [:index, :show]
  end

  scope "/", Store do
    pipe_through :protected
    # Add your protected routes here
    resources "/products", ProductController, except: [:index, :show]
  end

end
