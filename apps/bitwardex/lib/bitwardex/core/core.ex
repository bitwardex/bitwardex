defmodule Bitwardex.Core do
  @moduledoc """
  The Core context.
  """

  alias Bitwardex.Core.Managers.Cipher, as: CipherManager
  alias Bitwardex.Core.Managers.Folder, as: FolderManager

  defdelegate list_folders(user_id), to: FolderManager
  defdelegate get_folder(user_id, id), to: FolderManager
  defdelegate create_folder(params), to: FolderManager
  defdelegate update_folder(folder, arams), to: FolderManager
  defdelegate delete_folder(folder), to: FolderManager

  defdelegate list_ciphers(user_id), to: CipherManager
  defdelegate get_cipher(user_id, cipher_id), to: CipherManager
  defdelegate create_cipher(params), to: CipherManager
  defdelegate update_cipher(cipher, arams), to: CipherManager
  defdelegate delete_cipher(cipher), to: CipherManager
end
