defmodule ExRepositoryWeb.CatalogView do
  use ExRepositoryWeb, :view

  def render("index.json", %{resources: resources}) do
    %{
      resources: Enum.map(resources, &resource_json/1)
    }
  end

  def resource_json(resource) do
    %{
      internal_resource: resource.internal_resource,
      metadata: resource.metadata,
      inserted_at: resource.inserted_at,
      updated_at: resource.updated_at
    }
  end
end
