defmodule Rumours.Accounts.Scheduler do
  alias Rumours.Accounts.Workers.WelcomeUserMailer

  def deliver_welcome_user_email(
        email,
        username,
        token,
        domain
      ) do
    %{email: email, username: username, token: token, domain: domain}
    |> WelcomeUserMailer.new()
    |> Oban.insert()
  end
end
