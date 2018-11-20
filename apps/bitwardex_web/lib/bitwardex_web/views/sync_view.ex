defmodule BitwardexWeb.SyncView do
  use BitwardexWeb, :view

  alias BitwardexWeb.CiphersView
  alias BitwardexWeb.FoldersView

  def render("sync.json", %{current_user: user, exclude_domains: true}) do
    %{
      "Profile" => render_profile(user),
      "Folders" => render_folders(user.folders),
      "Ciphers" => render_ciphers(user.ciphers),
      "Object" => "sync"
    }
  end

  def render("sync.json", %{current_user: user}) do
    %{
      "Profile" => render_profile(user),
      "Folders" => render_folders(user.folders),
      "Ciphers" => render_ciphers(user.ciphers),
      "Domains" => [],
      "Object" => "sync"
    }
  end

  defp render_profile(user) do
    %{
      "Id" => user.id,
      "Name" => user.name,
      "Email" => user.email,
      "EmailVerified" => user.email_verified,
      "Premium" => user.premium,
      "MasterPasswordHint" => user.master_password_hint,
      "Culture" => user.culture,
      "TwoFactorEnabled" => false,
      "Key" => user.key,
      "PrivateKey" => nil,
      "SecurityStamp" => user.id,
      "Organizations" => [],
      "Object" => "profile"
    }
  end

  def render_folders(folders) do
    Enum.map(folders, fn folder ->
      render(FoldersView, "show.json", folder: folder)
    end)
  end

  def render_ciphers(ciphers) do
    Enum.map(ciphers, fn cipher ->
      render(CiphersView, "show.json", cipher: cipher)
    end)
  end
end
