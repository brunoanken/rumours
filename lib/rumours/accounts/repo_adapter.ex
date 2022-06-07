defmodule Rumours.Accounts.RepoAdapter do
  import Ecto.Changeset

  alias Rumours.Repo
  alias Rumours.Accounts.User

  def create_user(user_changeset) do
    user_changeset
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> Repo.insert()
  end

  def get_user_by(params), do: Repo.get_by(User, params)
end
