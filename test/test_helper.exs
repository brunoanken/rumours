defmodule Rumours.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Oban.Testing, repo: Rumours.Repo
    end
  end
end

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Rumours.Repo, :manual)
