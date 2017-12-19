defmodule ExRepositoryWeb.Router do
  use ExRepositoryWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json", "json-api"]
    plug JaSerializer.Deserializer
  end

  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug ExRepositoryWeb.Guardian.AuthPipeline
    plug JaSerializer.Deserializer
  end

  scope "/", ExRepositoryWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api/v1", ExRepositoryWeb do
    pipe_through :api_auth

    get "/catalog", CatalogController, :index
    post "/catalog", CatalogController, :create
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", ExRepositoryWeb do
    pipe_through :api_auth

    get "/catalog", CatalogController, :index
    post "/catalog", CatalogController, :create

    resources "/users", UserController, except: [:new, :edit]
    get "/user/current", UserController, :current, as: :current_user
    delete "/logout", AuthController, :delete
  end

  scope "/api/v1/auth", ExRepositoryWeb do
    pipe_through :api

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end
end
