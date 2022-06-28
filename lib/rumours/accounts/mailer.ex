defmodule Rumours.Accounts.Mailer do
  # The name here would be NotifierAdapter, MailerAdapter to follow the _Adapter pattern
  # But I can try out some stuff and compare with the RepoAdapter naming
  # Possible names: Notifier, Mailer
  # A possible pattern to follow could be moduling the adapters, like:
  # Rumours.Accounts.Adapters.Repo
  # Rumours.Accounts.Adapters.Mailer
  import Swoosh.Email
  alias Rumours.Mailer

  def deliver_welcome_user(
        email,
        username,
        confirmation_token,
        confirmation_website_url
      ) do
    from_email_address = Application.get_env(:rumours, :email_address)

    new()
    |> to({username, email})
    |> from({"Rumours", from_email_address})
    |> subject("Welcome to Rumours, #{username}!")
    |> html_body(
      "<h1>Hello, #{username}!</h1><p>Welcome to Rumours, your personal music catalog!\nTo confirm your account, please visit the following link: <a href=\"#{confirmation_website_url}/#{confirmation_token}\">#{confirmation_website_url}/#{confirmation_token}</a></p>"
    )
    |> text_body(
      "Hello, #{username}!\nWelcome to Rumours, your personal music catalog! To confirm your account, please visit the following link: #{confirmation_website_url}/#{confirmation_token}"
    )
    |> Mailer.deliver()
  end
end
