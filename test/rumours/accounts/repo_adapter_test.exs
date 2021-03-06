defmodule Rumours.Accounts.RepoAdapterTest do
  use Rumours.DataCase
  import Rumours.AccountsFixtures

  alias Rumours.Accounts.{RepoAdapter, User}

  describe "create_user/1" do
    test "creates a user when data is valid" do
      assert {:ok, %User{}} =
               %User{}
               |> User.changeset(%{
                 email: "valid@email.com",
                 username: "cool_name",
                 password: "password"
               })
               |> RepoAdapter.create_user()
    end

    test "errors when data is invalid" do
      assert {:error, %Ecto.Changeset{valid?: false}} =
               %User{} |> User.changeset(%{}) |> RepoAdapter.create_user()
    end

    test "errors when email has already been taken" do
      assert {:ok, %User{}} =
               %User{}
               |> User.changeset(%{
                 email: "valid@email.com",
                 username: "cool_name",
                 password: "password"
               })
               |> RepoAdapter.create_user()

      assert {:error, %Ecto.Changeset{valid?: false} = changeset} =
               %User{}
               |> User.changeset(%{
                 email: "valid@email.com",
                 username: "awesome_name",
                 password: "password"
               })
               |> RepoAdapter.create_user()

      assert %{email: ["has already been taken"]} = errors_on(changeset)
    end

    test "errors when username has already been taken" do
      assert {:ok, %User{}} =
               %User{}
               |> User.changeset(%{
                 email: "valid@email.com",
                 username: "cool_name",
                 password: "password"
               })
               |> RepoAdapter.create_user()

      assert {:error, %Ecto.Changeset{valid?: false} = changeset} =
               %User{}
               |> User.changeset(%{
                 email: "other@email.com",
                 username: "cool_name",
                 password: "password"
               })
               |> RepoAdapter.create_user()

      assert %{username: ["has already been taken"]} = errors_on(changeset)
    end
  end

  describe "get_user_by/1" do
    test "returns a user when data matches an existing user" do
      user = user_fixture()
      assert {:ok, %User{}} = RepoAdapter.get_user_by(email: user.email)
    end

    test "returns not found error when data does not match an existing user" do
      assert {:error, :not_found} = RepoAdapter.get_user_by(email: "random@email.com")
    end
  end

  describe "update_user/1" do
    test "updates the user when data is valid" do
      user = user_fixture()

      refute user.confirmed_at

      assert {:ok, %User{confirmed_at: confirmed_at}} =
               user |> User.confirm_changeset() |> RepoAdapter.update_user()

      refute is_nil(confirmed_at)
    end
  end
end
