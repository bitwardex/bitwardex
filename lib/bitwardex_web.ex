defmodule BitwardexWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use BitwardexWeb, :controller
      use BitwardexWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: BitwardexWeb
      import Plug.Conn
      import BitwardexWeb.Gettext
      alias BitwardexWeb.Router.Helpers, as: Routes

      def current_user(conn) do
        conn
        |> Map.get(:assigns, %{})
        |> Map.get(:current_user)
      end
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/bitwardex_web/templates",
        namespace: BitwardexWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      import BitwardexWeb.ErrorHelpers
      import BitwardexWeb.Gettext
      use Phoenix.HTML
      alias BitwardexWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import BitwardexWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
