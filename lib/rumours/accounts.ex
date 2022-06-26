defmodule Rumours.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Rumours.Accounts.{RepoAdapter, User, Scheduler}
  alias Rumours.Token

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    with {:ok, %User{email: email, username: username} = user} <-
           %User{}
           |> User.changeset(attrs)
           |> RepoAdapter.create_user(),
         {:ok, token} <- Token.generate_new_account_token(user),
         {:ok, _oban_job} <-
           Scheduler.deliver_welcome_user_email(
             email,
             username,
             token,
             Application.get_env(:rumours, :website)[:domain]
           ) do
      {:ok, user}
    end
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
    with {:ok, %User{} = user} <- RepoAdapter.get_user_by(email: email),
         {:ok, _user} <- Argon2.check_pass(user, password) do
      {:ok, user}
    end
  end

  def confirm_user(token) do
    with {:ok, user_id} <- Token.verify_new_account_token(token),
         {:ok, %User{} = user} = RepoAdapter.get_user_by(id: user_id) do
      case user do
        %User{confirmed_at: nil} -> user |> User.confirm_changeset() |> RepoAdapter.update_user()
        _ -> {:ok, user}
      end
    end
  end
end
