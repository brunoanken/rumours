defmodule Rumours.AccountsTest do
  use Rumours.DataCase

  alias Rumours.Accounts

  describe "users" do
    alias Rumours.Accounts.User

    import Rumours.AccountsFixtures

    @invalid_attrs %{email: nil, password: nil, username: nil}

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        email: "valid@email.com",
        password: "securep@ssword",
        username: "cool_name"
      }

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.email == "valid@email.com"
      assert user.username == "cool_name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "login/2 with invalid credentials returns unauthorized error" do
      user_fixture()

      assert {:error, "invalid password"} = Accounts.login("valid@email.com", "wrong_pass")
    end

    test "login/2 with valid credentials returns ok and the user data" do
      user_fixture(%{email: "valid@email.com", password: "mypass"})

      assert {:ok, %User{email: "valid@email.com"}} = Accounts.login("valid@email.com", "mypass")
    end
  end
end