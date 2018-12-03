defmodule BitwardexWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :bitwardex_web

  plug BitwardexWeb.IndexFilePlug

  # Hacky way to declare the websocket, because Phoenix adds the /websocket at
  # the end of the routes, and we cannot have that URL.
  def __handler__(["notifications", "hub"], _opts),
    do:
      {:websocket, BitwardexWeb.HubSocket,
       Keyword.merge(Phoenix.Transports.WebSocket.default_config(), timeout: 7_200_000)}

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :bitwardex_web,
    gzip: true,
    only:
      ~w(app connectors fonts images locales scripts browserconfig.xml duo-connector.html favicon.ico index.html manifest.json u2f-connector.html version.json)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_bitwardex_web_key",
    signing_salt: "BeyrL9Jf"

  def __handler__("/notifications/hub", _opts),
    do: {:websocket, BitwardexWeb.HubSocket, Phoenix.Transports.WebSocket.default_config()}

  plug BitwardexWeb.Router
end
