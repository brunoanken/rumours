defmodule Rumours.Accounts.Workers.WelcomeUserMailerTest do
  use Rumours.Case, async: true
  import Swoosh.TestAssertions

  test "delivers a welcome user email" do
    {:ok, _} =
      perform_job(Rumours.Accounts.Workers.WelcomeUserMailer, %{
        "email" => "cool_user@email.com",
        "username" => "cool_user",
        "token" => "confirmation_token",
        "domain" => "website_confirmation_address"
      })

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
