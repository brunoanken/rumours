defmodule Rumours.Accounts.MailerTest do
  use ExUnit.Case, async: true
  import Swoosh.TestAssertions

  alias Rumours.Accounts.{Mailer, User}

  test "deliver_welcome_user/1" do
    assert {:ok, _response} =
             Mailer.deliver_welcome_user(
               %User{username: "cool_user", email: "cool_user@email.com"},
               "confirmation_token",
               "website_confirmation_address"
             )

    assert_email_sent(
      subject: "Welcome to Rumours, cool_user!",
      to: {"cool_user", "cool_user@email.com"},
      text_body:
        ~r/Hello, cool_user!\nWelcome to Rumours, your personal music catalog! To confirm your account, please visit the following link: website_confirmation_address\/confirmation_token/,
      html_body:
        ~r/<h1>Hello, cool_user!<\/h1><p>Welcome to Rumours, your personal music catalog!\nTo confirm your account, please visit the following link: <a href=\"website_confirmation_address\/confirmation_token\">website_confirmation_address\/confirmation_token<\/a><\/p>/
    )
  end
end
