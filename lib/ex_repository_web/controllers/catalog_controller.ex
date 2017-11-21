defmodule ExRepositoryWeb.CatalogController do
  use ExRepositoryWeb, :controller

  alias ExRepository.OrmResource

  def index(conn, _params) do
    resources = ExRepository.Repo.all(OrmResource)
    render conn, "index.json", resources: resources
  end
end
