defmodule Rumours.Repo do
  use Ecto.Repo,
    otp_app: :rumours,
    adapter: Ecto.Adapters.Postgres
end
