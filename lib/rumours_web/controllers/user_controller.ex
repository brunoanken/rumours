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

  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, %User{} = user} <- Accounts.login(email, password) do
      conn
      |> put_status(:ok)
      |> put_resp_cookie(
        "rumid",
        %{id: user.id, email: user.email, username: user.username},
        http_only: true,
        secure: true,
        # 1 week
        max_age: 604_800,
        domain: conn.host,
        encrypt: true
      )
      |> render("show.json", %{user: user})
    else
      _ -> {:error, :unauthorized}
    end
  end

  def confirm(conn, %{"token" => token}) do
    with {:ok, %User{} = user} <- Accounts.confirm_user(token) do
      conn
      |> put_status(:ok)
      |> render("show.json", %{user: user})
    end
  end

  def logout(conn, _) do
    conn
    |> delete_resp_cookie(
      "rumid",
      http_only: true,
      secure: true,
      domain: conn.host
    )
    |> send_resp(:ok, "")
  end
end
