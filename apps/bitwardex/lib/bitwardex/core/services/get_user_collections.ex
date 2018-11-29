defmodule Bitwardex.Core.Services.GetUserCollections do
  @moduledoc """
  Service to get all user's accesible collections
  """

  alias Bitwardex.Accounts.Schemas.User

  alias Bitwardex.Repo

  @doc """
  Service to get all user-s available collections, and if they are read
  only or not.

  It gets a user schema and return a list of tuples like:
  `[{collection, read_only}]`, where `read_only` is a boolean.
  """
  def call(%User{} = user) do
    user_preloaded =
      Repo.preload(user,
        user_organizations: [organization: [:collections], user_collections: [:collection]]
      )

    collections_organizations =
      user_preloaded
      |> Map.get(:user_organizations)
      |> Enum.filter(&(&1.access_all and &1.status == 2))
      |> Enum.reduce([], fn org_user, acc ->
        acc ++ org_user.organization.collections
      end)
      |> Enum.map(&{&1, false})

    collections_user =
      user_preloaded
      |> Map.get(:user_organizations)
      |> Enum.filter(&(&1.status == 2))
      |> Enum.reduce([], fn user_org, acc ->
        acc ++ user_org.user_collections
      end)
      |> Enum.map(&{&1.collection, &1.read_only})

    collections_organizations ++ collections_user
  end
end
