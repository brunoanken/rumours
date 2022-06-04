defmodule RumoursWeb.UserController do
  use RumoursWeb, :controller

  alias Rumours.Accounts
  alias Rumours.Accounts.User

  action_fallback RumoursWeb.FallbackController

  def create(conn, user_params) do
    with {:ok, %User{}} <- Accounts.create_user(user_params) do
      conn
      |> send_resp(:created, "")
    end
  end
end
