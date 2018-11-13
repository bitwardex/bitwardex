defmodule BitwardexWeb.Router do
  use BitwardexWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BitwardexWeb do
    pipe_through :api
  end
end
