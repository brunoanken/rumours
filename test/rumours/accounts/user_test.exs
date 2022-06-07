defmodule Rumours.Accounts.UserTest do
  use Rumours.DataCase, async: true
  alias Rumours.Accounts.User

  @valid_attrs %{
    email: "email@mail.com",
    password: "securep@ss",
    username: "Biruleibe"
  }

  describe "changeset/2" do
    test "returns with errors when email is not provided" do
      changeset = User.changeset(%User{}, %{email: ""})
      assert %{email: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns with errors when username is not provided" do
      changeset = User.changeset(%User{}, %{username: ""})
      assert %{username: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns with errors when password is not provided" do
      changeset = User.changeset(%User{}, %{password: ""})
      assert %{password: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns with errors when password is not at least five characters long" do
      changeset = User.changeset(%User{}, %{password: "1234"})
      assert %{password: ["should be at least 5 character(s)"]} = errors_on(changeset)
    end

    test "returns with errors when email does not match the required format" do
      changeset = User.changeset(%User{}, %{email: "almost@validcom"})
      assert %{email: ["has invalid format"]} = errors_on(changeset)
    end

    test "returns with errors when username is longer than 20 characters" do
      changeset = User.changeset(%User{}, %{username: "loooooooooooooooooong"})
      assert %{username: ["should be at most 20 character(s)"]} = errors_on(changeset)
    end

    test "returns with a password hash when data is valid" do
      %Ecto.Changeset{changes: %{password_hash: password_hash}} =
        User.changeset(%User{}, @valid_attrs)

      assert password_hash != ""
      refute is_nil(password_hash)
    end
  end

  describe "put_password_hash/1" do
    test "puts the password_hash when changeset is valid" do
      %Ecto.Changeset{changes: %{password_hash: password_hash}} =
        %User{} |> User.changeset(@valid_attrs) |> User.put_password_hash()

      assert password_hash != ""
      refute is_nil(password_hash)
    end
  end
end
