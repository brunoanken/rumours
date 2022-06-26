defmodule RumoursWeb.UserView do
  use RumoursWeb, :view
  alias RumoursWeb.UserView

  def render("index.json", %{users: users}) do
    render_many(users, UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      username: user.username,
      confirmed_at: user.confirmed_at
    }
  end
end
