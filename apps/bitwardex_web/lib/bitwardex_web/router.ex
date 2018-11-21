defmodule BitwardexWeb.Router do
  use BitwardexWeb, :router

  alias BitwardexWeb.Guardian.AuthPipeline, as: GuardianAuthPipeline

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BitwardexWeb do
    pipe_through :api

    post "/accounts/register", AccountsController, :register
    post "/accounts/prelogin", AccountsController, :prelogin

    scope "/" do
      pipe_through(GuardianAuthPipeline)

      get "/sync", SyncController, :sync

      get "/accounts/profile", AccountsController, :profile
      put "/accounts/profile", AccountsController, :update_profile
      post "/accounts/email-token", AccountsController, :request_email_change
      post "/accounts/email", AccountsController, :change_email
      post "/accounts/kdf", AccountsController, :change_encryption
      post "/accounts/password", AccountsController, :change_master_password
      get "/accounts/revision-date", AccountsController, :revision_date

      resources "/folders", FoldersController, only: [:create, :update, :delete]
      resources "/ciphers", CiphersController, only: [:create, :update, :delete]
      post "/ciphers/purge", CiphersController, :purge
    end
  end

  scope "/identity", BitwardexWeb do
    pipe_through :api

    post "/connect/token", AccountsController, :login
  end
end
