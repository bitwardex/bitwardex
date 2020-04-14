defmodule Bitwardex.Core.Queries.Collection do
  @moduledoc """
  Responsible of creating queries for User
  """

  import Ecto.Query, only: [from: 2]

  @spec by_user(query :: Ecto.Query.t(), user_id :: binary) :: Ecto.Query.t()
  def by_user(query, user_id) do
    from(collection in query,
      join: c in ^from("users_collections", where: [user_id: ^user_id]),
      where: collection.user_id == ^user_id
    )
  end

  @spec by_organization(query :: Ecto.Query.t(), organization_id :: binary) :: Ecto.Query.t()
  def by_organization(query, organization_id) do
    from(collection in query, where: collection.organization_id == ^organization_id)
  end
end
