defmodule BitwardexWeb.CiphersView do
  use BitwardexWeb, :view

  alias Bitwardex.Core.Schemas.Cipher

  def render("show.json", %{cipher: %Cipher{type: 1} = cipher}) do
    cipher
    |> render_base()
    |> Map.put("Login", render_nested(cipher.login))
  end

  def render("show.json", %{cipher: %Cipher{type: 2} = cipher}) do
    cipher
    |> render_base()
    |> Map.put("SecureNote", render_nested(cipher.secure_note))
  end

  def render("show.json", %{cipher: %Cipher{type: 3} = cipher}) do
    cipher
    |> render_base()
    |> Map.put("Card", render_nested(cipher.card))
  end

  def render("show.json", %{cipher: %Cipher{type: 4} = cipher}) do
    cipher
    |> render_base()
    |> Map.put("Identity", render_nested(cipher.identity))
  end

  defp render_base(cipher) do
    %{
      "FolderId" => cipher.folder_id,
      "Favorite" => cipher.favorite,
      "Edit" => true,
      "Id" => cipher.id,
      "OrganizationId" => nil,
      "Type" => cipher.type,
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
