defmodule BitwardexWeb.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :bitwardex_web,
    module: BitwardexWeb.Guardian

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
