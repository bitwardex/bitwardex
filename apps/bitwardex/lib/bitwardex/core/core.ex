defmodule Bitwardex.Core do
  @moduledoc """
  The Core context.
  """

  alias Bitwardex.Core.Managers.Folder, as: FolderManager

  defdelegate list_folders(user_id), to: FolderManager
  defdelegate get_folder(user_id, id), to: FolderManager
  defdelegate create_folder(params), to: FolderManager
  defdelegate update_folder(folder, arams), to: FolderManager
  defdelegate delete_folder(folder), to: FolderManager
  defdelegate change_folder(folder), to: FolderManager
end
