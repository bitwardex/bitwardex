defmodule Bitwardex.Accounts.Queries.Organization do
  @moduledoc """
  Responsible of creating queries for organizations
  """

  import Ecto.Query, only: [from: 2]

  @spec by_id(query :: Ecto.Query.t(), id :: Ecto.UUID.t()) :: Ecto.Query.t()
  def by_id(query, id) do
    from(organization in query, where: organization.id == ^id)
  end
end
