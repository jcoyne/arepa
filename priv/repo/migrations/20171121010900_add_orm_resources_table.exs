defmodule ExRepository.Repo.Migrations.AddOrmResourcesTable do
  use Ecto.Migration

  def up do
    create table("orm_resources") do
      add :metadata,          :map, default: "{}", null: false
      add :internal_resource, :string
      timestamps()
    end
    create index("orm_resources", ["metadata jsonb_path_ops"], using: "GIN")
    create index("orm_resources", ["metadata"], using: "GIN")

  end
end
