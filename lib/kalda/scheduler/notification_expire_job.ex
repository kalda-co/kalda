defmodule Kalda.Scheduler.NotificationExpireJob do
  def run do
    get_users()
    |> Enum.each(fn user ->
      Kalda.Forums.get_notifications(user, limit: 50)
    end)
  end
end
