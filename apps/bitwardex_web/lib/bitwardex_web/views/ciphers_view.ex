defmodule BitwardexWeb.CiphersView do
  use BitwardexWeb, :view

  def render("show.json", %{cipher: cipher}) do
    %{
      "FolderId" => cipher.folder_id,
      "Favorite" => cipher.favorite,
      "Edit" => true,
      "Id" => cipher.id,
      "OrganizationId" => nil,
      "Type" => cipher.type,
      "Login" => render_nested(cipher.login),
      "Name" => cipher.name,
      "Notes" => cipher.notes,
      "Fields" => render_fields(cipher.fields),
      "Attachments" => nil,
      "OrganizationUseTotp" => false,
      "RevisionDate" => NaiveDateTime.to_iso8601(cipher.updated_at),
      "Object" => "cipher"
    }
  end

  defp render_nested(nested) when is_map(nested) or is_list(nested) do
    nested
    |> Enum.map(fn
      {key, value} when is_map(value) ->
        {Macro.camelize(key), render_nested(value)}

      {key, value} when is_list(value) ->
        {Macro.camelize(key), Enum.map(value, &render_nested/1)}

      {key, value} ->
        {Macro.camelize(key), value}

      value ->
        render_nested(value)
    end)
    |> Enum.into(%{})
  end

  defp render_nested(value), do: value

  defp render_fields(fields) do
    Enum.map(fields, fn field ->
      %{
        "Name" => field.name,
        "Type" => field.type,
        "Value" => field.value
      }
    end)
  end
end
