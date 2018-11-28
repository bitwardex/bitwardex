defmodule Bitwardex.Core.Services.GetUserCiphers do
  @moduledoc """
  Service to get all user's accesible collections
  """

  alias Bitwardex.Accounts.Schemas.User

  alias Bitwardex.Repo

  def call(%User{} = user) do
    user_preloaded =
      Repo.preload(user,
        ciphers: [],
        user_collections: [collection: [:ciphers]],
        user_organizations: [organization: [:ciphers]]
      )

    ciphers_user = Map.get(user_preloaded, :ciphers)

    ciphers_collections_organizations =
      user_preloaded
      |> Map.get(:user_organizations)
      |> Enum.filter(& &1.access_all)
      |> Enum.map(& &1.organization.ciphers)
      |> Enum.reduce([], fn org_ciphers, acc ->
        acc ++ org_ciphers
      end)

    ciphers_collections_user =
      user_preloaded
      |> Map.get(:user_collections)
      |> Enum.reduce([], fn user_collection, acc ->
        acc ++ user_collection.collection.ciphers
      end)

    ciphers_user
    |> Kernel.++(ciphers_collections_organizations)
    |> Kernel.++(ciphers_collections_user)
    |> Repo.preload(:collections)
  end
end
