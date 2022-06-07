defmodule Rumours.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Rumours.Accounts.{RepoAdapter, User}

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> RepoAdapter.create_user()
  end

  @doc """
  Authenticates a user.

  ## Examples

      iex> login("valid@email.com", "correctpass")
      {:ok, %User{}}

      iex> create_user("valid@email.com", "wrongpass")
      {:error, :unauthorized}

  """
  def login(email, password) do
    %{email: email}
    |> RepoAdapter.get_user_by()
    |> Argon2.check_pass(password)
    |> case do
      {:ok, %User{} = user} -> {:ok, user}
      error -> error
    end
  end
end
