defmodule BitwardexWeb.Router do
  use BitwardexWeb, :router

  alias BitwardexWeb.Guardian.AuthPipeline, as: GuardianAuthPipeline

  pipeline :api do
    plug :accepts, ["json"]
    plug BitwardexWeb.SnakizeParamsPlug
  end

  scope "/api", BitwardexWeb do
    pipe_through :api

    post "/accounts/register", AccountsController, :register
    post "/accounts/prelogin", AccountsController, :prelogin
    post "/accounts/password-hint", AccountsController, :password_hint

    scope "/" do
      pipe_through(GuardianAuthPipeline)

      get "/sync", SyncController, :sync

      get "/accounts/profile", AccountsController, :profile
      get "/users/:id/public-key", AccountsController, :get_public_key
      get "/accounts/keys", AccountsController, :update_keys
      put "/accounts/profile", AccountsController, :update_profile
      post "/accounts/email-token", AccountsController, :request_email_change
      post "/accounts/email", AccountsController, :change_email
      post "/accounts/kdf", AccountsController, :change_encryption
      post "/accounts/password", AccountsController, :change_master_password
      get "/accounts/revision-date", AccountsController, :revision_date
      delete "/accounts", AccountsController, :delete

      resources "/folders", FoldersController, only: [:create, :update, :delete]
      resources "/ciphers", CiphersController, only: [:create, :update, :delete]
      get "/ciphers/:id/admin", CiphersController, :show
      post "/ciphers/admin", CiphersController, :create
      put "/ciphers/:id/admin", CiphersController, :update
      delete "/ciphers/:id/admin", CiphersController, :delete
      post "/ciphers/create", CiphersController, :create
      put "/ciphers/:id/collections-admin", CiphersController, :update_collections
      post "/ciphers/purge", CiphersController, :purge

      post "/organizations", OrganizationsController, :create
      get "/organizations/:id", OrganizationsController, :show
      put "/organizations/:id", OrganizationsController, :update
      delete "/organizations/:id", OrganizationsController, :delete
      get "/ciphers/organization-details", Organizations.CiphersController, :index

      scope "/organizations/:organization_id", Organizations do
        # Users
        get "/users", UsersController, :index
        get "/users/:id", UsersController, :show
        put "/users/:id", UsersController, :update
        post "/users/:id/delete", UsersController, :delete
        delete "/users/:id", UsersController, :delete
        post "/users/invite", UsersController, :invite
        post "/users/:id/accept", UsersController, :accept
        post "/users/:id/confirm", UsersController, :confirm
        post "/users/:id/reinvite", UsersController, :reinvite

        # Collections
        get "/collections", CollectionsController, :index
        get "/collections/:id/details", CollectionsController, :show
        post "/collections", CollectionsController, :create
        put "/collections/:id", CollectionsController, :update
        post "/collections/:id", CollectionsController, :update
        delete "/collections/:id", CollectionsController, :delete

        # Collection users
        get "/collections/:id/users", CollectionsController, :get_users
        post "/collections/:id/users", CollectionsController, :update_users
        put "/collections/:id/users", CollectionsController, :update_users
      end

      post "/organizations/:organization_id/collections/:id/delete",
           CollectionsController,
           :delete
    end
  end

  scope "/identity", BitwardexWeb do
    pipe_through :api

    post "/connect/token", AccountsController, :login
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
