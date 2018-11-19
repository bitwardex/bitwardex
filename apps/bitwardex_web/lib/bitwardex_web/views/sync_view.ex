defmodule BitwardexWeb.SyncView do
  use BitwardexWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render("sync.json", %{current_user: user}) do
    %{
      "Profile" => render_profile(user),
      "Folders" => [],
      "Ciphers" => [],
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
