defmodule RumoursWeb.UserControllerTest do
  use RumoursWeb.ConnCase

  import Rumours.AccountsFixtures

  alias Rumours.Token

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "returns empty response body when data is valid", %{conn: conn} do
      conn =
        post(conn, "/v1/users", %{
          email: "valid@email.com",
          password: "securep@ssword",
          username: "cool_name"
        })

      assert conn.resp_body == ""
      assert conn.status == 201
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, "/v1/users", %{})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "login" do
    test "renders unauthorized when credentials are invalid", %{conn: conn} do
      user = user_fixture()
      conn = post(conn, "/v1/users/login", %{email: user.email, password: "wrong_pass"})
      assert conn.resp_body == ""
      assert conn.status == 401
    end

    test "renders a proper response when credentials are valid", %{conn: conn} do
      user = user_fixture()
      conn = post(conn, "/v1/users/login", %{email: user.email, password: user.password})
      assert response = json_response(conn, 200)
      assert response["email"] == user.email
      assert response["id"] == user.id
      assert response["username"] == user.username
    end

    test "sends a secure cookie to the client", %{conn: conn} do
      user = user_fixture()
      conn = post(conn, "/v1/users/login", %{email: user.email, password: user.password})

      {_, cookie} =
        Enum.find(conn.resp_headers, fn {header_name, _} -> header_name === "set-cookie" end)

      assert String.contains?(cookie, "rumid=")
      assert String.contains?(cookie, "secure")
      assert String.contains?(cookie, "HttpOnly")
    end
  end

  describe "confirm/2" do
    test "renders a user when user is successfuly confirmed", %{conn: conn} do
      user = user_fixture()
      {:ok, token} = Token.generate_new_account_token(user)

      conn = patch(conn, "/v1/users/confirm/#{token}")
      assert response = json_response(conn, 200)
      assert response["email"] == user.email
      assert response["id"] == user.id
      assert response["username"] == user.username
      refute is_nil(response["confirmed_at"])
    end

    test "renders an error when user confirmation fails", %{conn: conn} do
      token = "b136b53e-7397-4e61-be9e-3d44e311da15"

      conn = patch(conn, "/v1/users/confirm/#{token}")
      assert response = json_response(conn, 400)
      refute is_nil(response["errors"])
    end
  end
end
