defmodule BitwardexWeb.NotificationsView do
  use BitwardexWeb, :view

  def render("negotiate.json", %{connection_id: conn_id}) do
    %{
      "connectionId" => conn_id,
      "availableTransports" => [
        %{
          "transport" => "WebSockets",
          "transferFormats" => ["Text", "Binary"]
        }
      ]
    }
  end
end
