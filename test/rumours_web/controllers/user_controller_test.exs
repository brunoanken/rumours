defmodule RumoursWeb.UserControllerTest do
  use RumoursWeb.ConnCase

  import Rumours.AccountsFixtures

  alias Rumours.Accounts.User

  @create_attrs %{
    email: "valid@email.com",
    password: "securep@ssword",
    username: "cool_name"
  }
  @invalid_attrs %{email: nil, password_hash: nil, username: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, "/v1/users", @create_attrs)
      assert conn.resp_body == ""
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
