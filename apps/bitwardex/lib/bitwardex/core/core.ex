defmodule Bitwardex.Core do
  @moduledoc """
  The Core context.
  """

  alias Bitwardex.Core.Managers.Cipher, as: CipherManager
  alias Bitwardex.Core.Managers.CipherFolder, as: CipherFolderManager
  alias Bitwardex.Core.Managers.Collection, as: CollectionManager
  alias Bitwardex.Core.Managers.Folder, as: FolderManager

  alias Bitwardex.Core.Services.GetUserCiphers
  alias Bitwardex.Core.Services.GetUserCollections
  alias Bitwardex.Core.Services.UpdateCollectionUsers

  # Folders

  defdelegate list_folders(user_id), to: FolderManager
  defdelegate get_folder(user_id, id), to: FolderManager
  defdelegate create_folder(params), to: FolderManager
  defdelegate update_folder(folder, params), to: FolderManager
  defdelegate delete_folder(folder), to: FolderManager

  # Ciphers

  defdelegate list_ciphers_by_user(user_id), to: CipherManager
  defdelegate list_ciphers_by_organization(organization_id), to: CipherManager
  defdelegate get_cipher(cipher_id), to: CipherManager
  defdelegate create_cipher(user, params), to: CipherManager
  defdelegate update_cipher(cipher, user, params), to: CipherManager
  defdelegate delete_cipher(cipher), to: CipherManager

  defdelegate get_user_ciphers(user),
    to: GetUserCiphers,
    as: :call

  # CipherFolder

  defdelegate get_cipher_folder(cipher, user), to: CipherFolderManager
  defdelegate insert_or_update_cipher_folder(cipher, user, folder), to: CipherFolderManager
  defdelegate delete_cipher_folder(cipher, user), to: CipherFolderManager

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

  defdelegate get_user_collections(user),
    to: GetUserCollections,
    as: :call
end
