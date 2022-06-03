defmodule Rumours.Accounts.RepoAdapter do
  import Ecto.Changeset

  alias Rumours.Repo

  def create_user(user_changeset) do
    user_changeset
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> Repo.insert()
  end
end
