defmodule BitwardexWeb.CiphersView do
  use BitwardexWeb, :view

  def render("cipher.json", %{current_user: _user, cipher: cipher}) do
    base_struct = %{
      "Name" => cipher.name,
      # "FolderId" => cipher.folder_id,
      "Favorite" => cipher.favorite,
      "Edit" => true,
      "Id" => cipher.id,
      "OrganizationId" => cipher.organization_id,
      "CollectionIds" => Enum.map(cipher.collections, & &1.id),
      "Type" => cipher.type,
      "Notes" => cipher.notes,
      "Fields" => cipher.fields,
      "Attachments" => [],
      "OrganizationUseTotp" => false,
      "RevisionDate" => NaiveDateTime.to_iso8601(cipher.updated_at),
      "Object" => "cipher"
    }

    case cipher.type do
      1 -> Map.put(base_struct, "Login", cipher.login)
      2 -> Map.put(base_struct, "SecureNote", cipher.secure_note)
      3 -> Map.put(base_struct, "Card", cipher.card)
      4 -> Map.put(base_struct, "Identity", cipher.identity)
      _ -> base_struct
    end
  end
end
