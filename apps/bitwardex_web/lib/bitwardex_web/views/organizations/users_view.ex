defmodule BitwardexWeb.Organizations.UsersView do
  use BitwardexWeb, :view

  def render("user_organization.json", %{user_organization: user_org}) do
    %{
      "Id" => user_org.id,
      "UserId" => user_org.user_id,
      "AccessAll" => user_org.access_all,
      "Type" => user_org.type,
      "Status" => user_org.status,
      "Collections" => Enum.map(user_org.user_collections, &render_user_collection/1),
      "Object" => "organizationUserDetails"
    }
  end

  def render("user_organization_details.json", %{user_organization: user_org}) do
    %{
      "Id" => user_org.id,
      "UserId" => user_org.user.id,
      "Name" => user_org.user.name,
      "Email" => user_org.user.email,
      "Type" => user_org.type,
      "Status" => user_org.status,
      "AccessAll" => user_org.access_all,
      "Object" => "organizationUserUserDetails"
    }
  end

  defp render_user_collection(user_collection) do
    %{
      "Id" => user_collection.collection_id,
      "ReadOnly" => user_collection.read_only
    }
  end
end
