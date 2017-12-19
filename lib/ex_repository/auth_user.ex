defmodule AuthUser do
  alias Ueberauth.Auth

  def basic_info(%Auth{} = auth) do
    {:ok,
      %{
        email: auth.info.email,
        name: auth.info.name
      }
    }
  end
end
