defmodule BitwardexWeb.Organizations.CollectionsView do
  use BitwardexWeb, :view

  def render("collection.json", %{collection: collection}) do
    %{
      "Id" => collection.id,
      "Name" => collection.name,
      "OrganizationId" => collection.organization_id,
      "Object" => "collection"
    }
  end

  def render("collection_details.json", %{collection: collection, read_only: read_only}) do
    %{
      "ReadOnly" => read_only,
      "Id" => collection.id,
      "OrganizationId" => collection.organization_id,
      "Name" => collection.name,
      "Object" => "collectionDetails"
    }
  end

  def render("collection_user.json", %{collection_user: collection_user}) do
    %{
      "Id" => collection_user.user_organization.id,
      "ReadOnly" => collection_user.read_only
    }
  end
end
