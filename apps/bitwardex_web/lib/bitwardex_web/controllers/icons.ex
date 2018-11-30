defmodule BitwardexWeb.IconsController do
  @moduledoc """
  Controller to handle icon operations
  """

  use BitwardexWeb, :controller

  def show(conn, %{"domain" => domain}) do
    redirect(conn, external: "https://icons.bitwarden.com/#{domain}/icon.png")
  end
end
