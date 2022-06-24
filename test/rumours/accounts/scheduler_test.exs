defmodule Rumours.Accounts.SchedulerTest do
  use Rumours.DataCase
  use Rumours.Case

  alias Rumours.Accounts.Scheduler

  describe "deliver_welcome_user_email/1" do
    test "schedules the deliver of the welcome user email" do
      assert {:ok, %Oban.Job{}} =
               Scheduler.deliver_welcome_user_email(
                 "valid@email.com",
                 "user_name",
                 "token",
                 "domain"
               )

      assert_enqueued(
        worker: Rumours.Accounts.Workers.WelcomeUserMailer,
        args: %{
          email: "valid@email.com",
          username: "user_name",
          token: "token",
          domain: "domain"
        },
        queue: :emails
      )
    end
  end
end
