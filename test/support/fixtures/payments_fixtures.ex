defmodule Kalda.PaymentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Kalda.Payments` context.
  """
  def past_datetime() do
    now = NaiveDateTime.local_now()
    NaiveDateTime.add(now, -96000)
  end

  def subscription_event(user, event \\ :subscription_created, attrs \\ %{}) do
    {:ok, subscription_event} = Kalda.Payments.create_subscription_event(user, event, attrs)
    subscription_event
  end

  def past_subscription_event(user, event \\ :subscription_created, attrs \\ %{}) do
    # {:ok, subscription_event} = Kalda.Payments.create_subscription_event(user, event, attrs)
    # subscription_event

    {:ok, subscription_event} =
      %Kalda.Payments.SubscriptionEvent{user_id: user.id, event: event}
      |> Kalda.Payments.SubscriptionEvent.changeset(attrs)
      |> Ecto.Changeset.force_change(:inserted_at, past_datetime())
      |> Ecto.Changeset.force_change(:updated_at, past_datetime())
      |> Kalda.Repo.insert()

    subscription_event
  end
end
