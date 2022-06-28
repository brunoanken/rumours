# Rumours

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Notes
  When deploying, set the following environment variables:
  - PHX_SERVER
  - DATABASE_URL
  - SECRET_KEY_BASE
  - PHX_HOST
  - SENDGRID_API_KEY
  - TOKEN_NEW_ACCOUNT_SALT
  - WEBSITE_DOMAIN
  - EMAIL_ADDRESS