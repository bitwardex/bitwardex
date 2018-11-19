defmodule Bitwardex.Accounts.Services.GenerateUserClaims do
  @moduledoc false

  alias Bitwardex.Accounts.Schemas.User

  def call(%User{} = user) do
    %{
      premium: user.premium,
      name: user.name,
      email: user.email,
      email_verified: user.email_verified
    }
  end
end
