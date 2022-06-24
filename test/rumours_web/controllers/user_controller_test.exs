defmodule RumoursWeb.UserControllerTest do
  use RumoursWeb.ConnCase

  import Rumours.AccountsFixtures

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
      conn = post(conn, "/v1/login", %{email: user.email, password: "wrong_pass"})
      assert conn.resp_body == ""
      assert conn.status == 401
    end

    test "renders a proper response when credentials are valid", %{conn: conn} do
      user = user_fixture()
      conn = post(conn, "/v1/login", %{email: user.email, password: user.password})
      assert response = json_response(conn, 200)
      assert response["email"] == user.email
      assert response["id"] == user.id
      assert response["username"] == user.username
    end

    test "sends a secure cookie to the client", %{conn: conn} do
      user = user_fixture()
      conn = post(conn, "/v1/login", %{email: user.email, password: user.password})

      {_, cookie} =
        Enum.find(conn.resp_headers, fn {header_name, _} -> header_name === "set-cookie" end)

      assert String.contains?(cookie, "rumid=")
      assert String.contains?(cookie, "secure")
      assert String.contains?(cookie, "HttpOnly")
    end
  end
end
