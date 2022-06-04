defmodule Rumours.Repo.Migrations.MakeConfirmedAtNullable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify(:confirmed_at, :naive_datetime, null: true, from: :naive_datetime)
    end
  end
end
