defmodule ExRepositoryWeb.CatalogController do
  use ExRepositoryWeb, :controller
  require IEx
  alias ExRepository.OrmResource
  alias ExRepository.Repo

  def index(conn, _params) do
    resources = ExRepository.Repo.all(OrmResource)
    render conn, "index.json", resources: resources
  end

  def create(conn, params) do
    changeset = OrmResource.changeset(
      %OrmResource{}, params)

    case Repo.insert(changeset) do
      {:ok, resource} ->
        conn
        |> put_status(:created)
        |> render("show.json", resource)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ExRepositoryWeb.ErrorView, "error.json", reason: changeset)
    end
  end
end
