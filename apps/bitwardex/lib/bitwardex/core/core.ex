defmodule Bitwardex.Core do
  @moduledoc """
  The Core context.
  """

  alias Bitwardex.Core.Managers.Cipher, as: CipherManager
  alias Bitwardex.Core.Managers.Collection, as: CollectionManager
  alias Bitwardex.Core.Managers.Folder, as: FolderManager

  alias Bitwardex.Core.Services.UpdateCollectionUsers

  # Folders

  defdelegate list_folders(user_id), to: FolderManager
  defdelegate get_folder(user_id, id), to: FolderManager
  defdelegate create_folder(params), to: FolderManager
  defdelegate update_folder(folder, params), to: FolderManager
  defdelegate delete_folder(folder), to: FolderManager

  # Ciphers

  defdelegate list_ciphers(user_id), to: CipherManager
  defdelegate get_cipher(user_id, cipher_id), to: CipherManager
  defdelegate create_cipher(params), to: CipherManager
  defdelegate update_cipher(cipher, params), to: CipherManager
  defdelegate delete_cipher(cipher), to: CipherManager

  # Collections

  defdelegate list_collections(organization_id), to: CollectionManager
  defdelegate get_collection_by_organization(organization_id, id), to: CollectionManager
  defdelegate get_collection_by_user(user_id, id), to: CollectionManager
  defdelegate create_collection(params), to: CollectionManager
  defdelegate update_collection(collection, params), to: CollectionManager
  defdelegate delete_collection(collection), to: CollectionManager

  defdelegate update_collection_users(collection, users_data),
    to: UpdateCollectionUsers,
    as: :call
end
