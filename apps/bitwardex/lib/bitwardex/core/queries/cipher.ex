defmodule Bitwardex.Core.Queries.Cipher do
  @moduledoc """
  Responsible of creating queries for User
  """

  import Ecto.Query, only: [from: 2]

  @spec by_user(query :: Ecto.Query.t(), user_id :: binary) :: Ecto.Query.t()
  def by_user(query, user_id) do
    from(cipher in query, where: cipher.user_id == ^user_id)
  end
end
