defmodule Rumours.TokenTest do
  use Rumours.DataCase, async: true

  alias Rumours.Token
  alias Rumours.Accounts.User

  describe "generate_new_account_token/1" do
    test "returns a signed token" do
      user_id = "91b5ff6c-28c6-4102-8d42-35657381a6f8"
      {:ok, token} = Token.generate_new_account_token(%User{id: user_id})

      assert {:ok, ^user_id} =
               Phoenix.Token.verify(
                 RumoursWeb.Endpoint,
                 Application.get_env(:rumours, :token)[:new_account_salt],
                 token
               )
    end
  end

  describe "verify_new_account_token/1" do
    test "errors when token is expired" do
      user_id = "351278dd-2619-4f80-8557-aa7db20402c8"
      {:ok, token} = Token.generate_new_account_token(%User{id: user_id}, 1)

      # wait for the token to expire
      Process.sleep(1100)

      assert {:error, :expired} = Token.verify_new_account_token(token, 1)
    end

    test "errors when token is invalid" do
      assert {:error, :invalid} = Token.verify_new_account_token("invalid_token", 1)
    end

    test "returns success when token is valid" do
      user_id = "182bea72-b94d-49c0-9046-84b94186f97a"
      {:ok, token} = Token.generate_new_account_token(%User{id: user_id})

      assert {:ok, ^user_id} = Token.verify_new_account_token(token)
    end
  end
end
