defmodule Bitwardex.Accounts.Queries.User do
  @moduledoc """
  Responsible of creating queries for User
  """

  import Ecto.Query, only: [from: 2]

  @spec by_id(query :: Ecto.Query.t(), id :: Ecto.UUID.t()) :: Ecto.Query.t()
  def by_id(query, id) do
    from(user in query, where: user.id == ^id)
  end

  @spec by_email(query :: Ecto.Query.t(), email :: binary) :: Ecto.Query.t()
  def by_email(query, email) do
    from(user in query, where: user.email == ^email)
  end
end
