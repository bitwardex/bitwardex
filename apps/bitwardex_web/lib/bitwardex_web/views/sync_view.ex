defmodule BitwardexWeb.SyncView do
  use BitwardexWeb, :view

  def render("sync.json", %{current_user: user, ciphers: ciphers, collections: collections}) do
    %{
      "Profile" => user,
      "Folders" => user.folders,
      "Ciphers" => ciphers,
      "Collections" => Enum.map(collections, &render_user_collection/1),
      "Domains" => [],
      "Object" => "sync"
    }
  end

  defp render_user_collection({collection, read_only}) do
    %{
      "ReadOnly" => read_only,
      "Id" => collection.id,
      "OrganizationId" => collection.organization_id,
      "Name" => collection.name,
      "Object" => "collectionDetails"
    }
  end
end
