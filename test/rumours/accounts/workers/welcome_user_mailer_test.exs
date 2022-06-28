defmodule Rumours.Accounts.Workers.WelcomeUserMailerTest do
  use Rumours.Case, async: true
  import Swoosh.TestAssertions

  test "delivers a welcome user email" do
    {:ok, _} =
      perform_job(Rumours.Accounts.Workers.WelcomeUserMailer, %{
        "email" => "e@mail.com",
        "username" => "username",
        "token" => "token",
        "domain" => "domain"
      })
  end
end
