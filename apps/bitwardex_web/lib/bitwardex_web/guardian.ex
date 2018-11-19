defmodule BitwardexWeb.Guardian do
  use Guardian,
    otp_app: :bitwardex_web

  alias Bitwardex.Accounts
  alias Bitwardex.Accounts.Schemas.User

  def subject_for_token(%User{} = user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]

    case Accounts.get_user(id) do
      {:ok, user} -> {:ok, user}
      _err -> {:error, :not_found}
    end
  end
end
