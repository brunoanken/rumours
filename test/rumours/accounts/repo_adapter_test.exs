defmodule Rumours.Accounts.RepoAdapterTest do
  use Rumours.DataCase

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
end
