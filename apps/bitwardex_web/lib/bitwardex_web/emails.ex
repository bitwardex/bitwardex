defmodule BitwardexWeb.Emails do
  import Bamboo.Email
  use Bamboo.Phoenix, view: BitwardexWeb.EmailsView

  alias Bitwardex.Accounts.Schemas.Organization
  alias Bitwardex.Accounts.Schemas.User

  def invite_email(%User{} = user, %Organization{} = organization, token) do
    base_email()
    |> to(user.email)
    |> subject("Join #{organization.name}")
    |> assign(:token, token)
    |> assign(:organization, organization)
    |> assign(:user, user)
    |> render("invite.html")
  end

  defp base_email do
    host = Application.get_env(:bitwardex_web, BitwardexWeb.Endpoint)[:url][:host]

    new_email()
    |> from("no-reply@#{host}")
    |> put_html_layout({BitwardexWeb.EmailsView, "layout.html"})
  end
end
