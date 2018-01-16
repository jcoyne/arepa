defmodule ExRepositoryWeb.AuthController do
  use ExRepositoryWeb, :controller
  plug Ueberauth
  import Ecto.Query
  require Logger
  alias ExRepository.Users.User
  alias ExRepository.Repo
  alias ExRepositoryWeb.Guardian
  alias MyApp.UserQuery

  plug :scrub_params, "user" when action in [:sign_in_user]

  def request(_params) do
  end

  def delete(conn, _params) do
    # Sign out the user
    conn
    |> put_status(200)
    |> Guardian.Plug.sign_out(conn)
  end

  def callback(%{assigns: %{ueberauth_failure: failure}} = conn, _params) do
    # This callback is called when the user denies the app to get the data from the oauth provider
    # Logger.info "denied: #{Enum.map(failure.errors, & &1.message) |> Enum.join(", ")}"

    conn
    |> put_status(401)
    |> render(ExRepositoryWeb.ErrorView, "401.json-api")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case AuthUser.basic_info(auth) do
      {:ok, user} ->
        sign_in_user(conn, %{"user" => user})
    end

    case AuthUser.basic_info(auth) do
      {:ok, user} ->
        conn
        |> render(ExRepositoryWeb.UserView, "show.json-api", %{data: user})
      {:error} ->
        Logger.info "basic info"
        conn
        |> put_status(401)
        |> render(ExRepositoryWeb.ErrorView, "401.json-api")
    end
  end

  def sign_in_user(conn, %{"user" => user}) do
    try do
      # Attempt to retrieve exactly one user from the DB, whose
      # email matches the one provided with the login request
      user = User
      |> where(email: ^user.email)
      |> Repo.one!

      cond do
        true ->
          # Successful login
          # Encode a JWT
          { :ok, jwt, _ } = Guardian.encode_and_sign(user, :token)

          auth_conn = Guardian.Plug.api_sign_in(conn, user)
          jwt = Guardian.Plug.current_token(auth_conn)
          {:ok, claims} = Guardian.Plug.claims(auth_conn)

          auth_conn
          |> put_resp_header("authorization", "Bearer #{jwt}")
          |> json(%{access_token: jwt}) # Return token to the client

        false ->
          Logger.info "Unsuccessful sign in"
          # Unsuccessful login
          conn
          |> put_status(401)
          |> render(ExRepositoryWeb.ErrorView, "401.json-api")
      end
    rescue
      e ->
        IO.inspect e # Print error to the console for debugging

        # Successful registration
        sign_up_user(conn, %{"user" => user})
    end
  end

  def sign_up_user(conn, %{"user" => user}) do
    changeset = User.changeset %User{}, %{email: user.email,
      name: user.name,
      auth_provider: "google"}

    case Repo.insert changeset do
      {:ok, user} ->
        # Encode a JWT
        { :ok, jwt, _ } = Guardian.encode_and_sign(user)

        conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> json(%{access_token: jwt}) # Return token to the client
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(ExRepositoryWeb.ErrorView, "422.json-api")
    end
  end

  def unauthenticated(conn, params) do
    Logger.info "unauthenticated"

    conn
    |> put_status(401)
    |> render(ExRepositoryWeb.ErrorView, "401.json-api")
  end

  def unauthorized(conn, params) do
    conn
    |> put_status(403)
    |> render(ExRepositoryWeb.ErrorView, "403.json-api")
  end

  def already_authenticated(conn, params) do
    conn
    |> put_status(200)
    |> render(ExRepositoryWeb.ErrorView, "200.json-api")
  end

  def no_resource(conn, params) do
    conn
    |> put_status(404)
    |> render(ExRepositoryWeb.ErrorView, "404.json-api")
  end
end
