defmodule ExRepository.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExRepository.Users.User


  schema "users" do
    field :auth_provider, :string
    field :email, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :auth_provider, :name])
    |> validate_required([:email, :auth_provider, :name])
  end
end
