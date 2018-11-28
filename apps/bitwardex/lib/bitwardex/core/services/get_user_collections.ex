defmodule Bitwardex.Core.Services.GetUserCollections do
  @moduledoc """
  Service to get all user's accesible collections
  """

  alias Bitwardex.Accounts.Schemas.User

  alias Bitwardex.Repo

  def call(%User{} = user) do
    user_preloaded =
      Repo.preload(user,
        user_collections: [:collection],
        user_organizations: [organization: [:collections]]
      )

    collections_organizations =
      user_preloaded
      |> Map.get(:user_organizations)
      |> Enum.filter(& &1.access_all)
      |> Enum.reduce([], fn org_user, acc ->
        acc ++ org_user.organization.collections
      end)
      |> Enum.map(&{&1, false})

    collections_user =
      user_preloaded
      |> Map.get(:user_collections)
      |> Enum.map(&{&1.collection, &1.read_only})

    collections_organizations ++ collections_user
  end
end
