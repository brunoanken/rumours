defmodule Rumours.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rumours.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "valid@email.com",
        password: "securep@ssword",
        username: "cool_name"
      })
      |> Rumours.Accounts.create_user()

    user
  end
end
