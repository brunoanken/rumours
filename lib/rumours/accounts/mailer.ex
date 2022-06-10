defmodule Rumours.Accounts.Mailer do
  # The name here would be NotifierAdapter, MailerAdapter to follow the _Adapter pattern
  # But I can try out some stuff and compare with the RepoAdapter naming
  # Possible names: Notifier, Mailer
  # A possible pattern to follow could be moduling the adapters, like:
  # Rumours.Accounts.Adapters.Repo
  # Rumours.Accounts.Adapters.Mailer
  import Swoosh.Email
  alias Rumours.Mailer

  def deliver_welcome_user(username, email, confirmation_link) do
    new()
    |> to({username, email})
    |> from({"Rumours", "contact@domain.com"})
    |> subject("Welcome to Rumours, #{username}!")
    |> html_body(
      "<h1>Hello, #{username}!</h1><p>Hello, #{username}!\nTo confirm your account, please visit the following link: <a href=\"#{confirmation_link}\">#{confirmation_link}</a></p>"
    )
    |> text_body(
      "Hello, #{username}!\nTo confirm your account, please visit the following link: #{confirmation_link}"
    )
    |> Mailer.deliver()
  end
end
