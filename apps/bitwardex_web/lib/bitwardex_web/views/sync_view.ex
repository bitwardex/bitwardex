defmodule BitwardexWeb.SyncView do
  use BitwardexWeb, :view

  def render("sync.json", %{current_user: user, exclude_domains: true}) do
    %{
      "Profile" => render_profile(user),
      "Folders" => user.folders,
      "Ciphers" => user.ciphers,
      "Object" => "sync"
    }
  end

  def render("sync.json", %{current_user: user}) do
    %{
      "Profile" => render_profile(user),
      "Folders" => user.folders,
      "Ciphers" => user.ciphers,
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
end
