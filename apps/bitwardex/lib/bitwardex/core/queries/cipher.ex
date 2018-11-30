defmodule Bitwardex.Core.Queries.Cipher do
  @moduledoc """
  Responsible of creating queries for User
  """

  import Ecto.Query, only: [from: 2]

  @spec by_user(query :: Ecto.Query.t(), user_id :: binary) :: Ecto.Query.t()
  def by_user(query, user_id) do
    from(cipher in query, where: cipher.user_id == ^user_id)
  end

  @spec by_organization(query :: Ecto.Query.t(), organization_id :: binary) :: Ecto.Query.t()
  def by_organization(query, organization_id) do
    from(cipher in query, where: cipher.organization_id == ^organization_id)
  end

  @spec preload_collections(query :: Ecto.Query.t()) :: Ecto.Query.t()
  def preload_collections(query) do
    from(cipher in query, preload: [:collections])
  end
end
