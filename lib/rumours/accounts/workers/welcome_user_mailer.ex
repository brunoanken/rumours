defmodule Rumours.Accounts.Workers.WelcomeUserMailer do
  use Oban.Worker,
    queue: :emails,
    max_attempts: 3,
    tags: ["email", "welcome_user"]

  alias Rumours.Accounts.Mailer

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{
          "email" => email,
          "username" => username,
          "token" => token,
          "domain" => domain
        }
      }) do
    Mailer.deliver_welcome_user(
      email,
      username,
      token,
      domain
    )
  end
end
