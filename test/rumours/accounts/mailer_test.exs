defmodule Rumours.Accounts.MailerTest do
  use ExUnit.Case, async: true
  import Swoosh.TestAssertions

  alias Rumours.Accounts.Mailer

  test "deliver_welcome_user/1" do
    assert {:ok, res} =
             Mailer.deliver_welcome_user(
               "cool_user",
               "cool_user@email.com",
               "https://linktoconfirmaccount.com"
             )

    assert_email_sent(
      subject: "Welcome to Rumours, cool_user!",
      to: {"cool_user", "cool_user@email.com"},
      text_body:
        ~r/Hello, cool_user!\nTo confirm your account, please visit the following link: https:\/\/linktoconfirmaccount.com/,
      html_body:
        ~r/<h1>Hello, cool_user!<\/h1><p>Hello, cool_user!\nTo confirm your account, please visit the following link: <a href=\"https:\/\/linktoconfirmaccount.com\">https:\/\/linktoconfirmaccount.com<\/a><\/p>/
    )
  end
end
