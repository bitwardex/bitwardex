defmodule BitwardexWeb.SyncView do
  use BitwardexWeb, :view

  def render("sync.json", %{current_user: user, exclude_domains: true}) do
    %{
      "Profile" => user,
      "Folders" => user.folders,
      "Ciphers" => user.ciphers,
      "Object" => "sync"
    }
  end

  def render("sync.json", %{current_user: user}) do
    %{
      "Profile" => user,
      "Folders" => user.folders,
      "Ciphers" => user.ciphers,
      "Domains" => [],
      "Object" => "sync"
    }
  end
end
