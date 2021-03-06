defmodule Rumours.AccountsTest do
  use Rumours.DataCase, async: true
  use Rumours.Case
  import Swoosh.TestAssertions

  alias Rumours.{Accounts, Token}

  describe "users" do
    alias Rumours.Accounts.User

    import Rumours.AccountsFixtures

    @invalid_attrs %{email: nil, password: nil, username: nil}
    @valid_attrs %{
      email: "valid@email.com",
      password: "securep@ssword",
      username: "cool_name"
    }

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "valid@email.com"
      assert user.username == "cool_name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_user/1 schedules the delivery of a welcome email when credentials are valid" do
      Accounts.create_user(@valid_attrs)

      assert_enqueued(
        worker: Rumours.Accounts.Workers.WelcomeUserMailer,
        queue: :emails
      )
    end

    test "create_user/1 delivers a welcome email when job is processed" do
      Accounts.create_user(@valid_attrs)

      assert %{success: 1, failure: 0} = Oban.drain_queue(queue: :emails)

      assert_email_sent(
        subject: "Welcome to Rumours, cool_name!",
        to: {"cool_name", "valid@email.com"}
      )
    end

    test "login/2 with invalid credentials returns unauthorized error" do
      user_fixture()

      assert {:error, "invalid password"} = Accounts.login("valid@email.com", "wrong_pass")
    end

    test "login/2 with valid credentials returns ok and the user data" do
      user_fixture(%{email: "valid@email.com", password: "mypass"})

      assert {:ok, %User{email: "valid@email.com"}} = Accounts.login("valid@email.com", "mypass")
    end

    test "login/2 with inexistent user returns not found error" do
      assert {:error, :not_found} = Accounts.login("any@email.com", "pass")
    end

    test "confirm_user/1 confirms the user when token is valid" do
      user = user_fixture(%{email: "valid@email.com", password: "mypass"})
      {:ok, token} = Token.generate_new_account_token(user)

      assert {:ok, %User{confirmed_at: confirmed_at}} = Accounts.confirm_user(token)
      refute is_nil(confirmed_at)
    end
  end
end
