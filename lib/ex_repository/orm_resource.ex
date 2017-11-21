defmodule ExRepository.OrmResource do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExRepository.OrmResource


  schema "orm_resources" do
    field :metadata, :map
    field :internal_resource, :string

    timestamps()
  end

  @doc false
  def changeset(%OrmResource{} = orm_resource, attrs) do
    orm_resource
    |> cast(attrs, [:metadata, :internal_resource])
    |> validate_required([:metadata, :internal_resource])
  end
end
