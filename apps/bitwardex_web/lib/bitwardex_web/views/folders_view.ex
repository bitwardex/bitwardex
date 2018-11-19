defmodule BitwardexWeb.FoldersView do
  use BitwardexWeb, :view

  def render("show.json", %{folder: folder}) do
    %{
      "Id" => folder.id,
      "Name" => folder.name,
      "RevisionDate" => NaiveDateTime.to_iso8601(folder.updated_at),
      "Object" => "folder"
    }
  end
end
