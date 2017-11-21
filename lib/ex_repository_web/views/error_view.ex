defmodule ExRepositoryWeb.ErrorView do
  use ExRepositoryWeb, :view

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  @doc """
  Renders an error from a changeset. `reason` can be either a string
  or a changeset.
  """
  def render("error.json", %{reason: reason}) do
    reason = cond do
      is_nil(reason) || reason == "" -> "Unknown error."
      is_bitstring(reason) -> reason
      true -> error_string_from_changeset(reason)
    end

    %{error: reason}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
