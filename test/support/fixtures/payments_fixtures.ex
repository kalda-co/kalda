defmodule Kalda.PaymentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Kalda.Payments` context.
  """
  def past_datetime() do
    now = NaiveDateTime.local_now()
    NaiveDateTime.add(now, -96000)
  end

  def subscription_event(user, name \\ :stripe_subscription_created) do
    Kalda.Payments.create_subscription_event!(user, name)
  end

  def past_subscription_event(user, name \\ :stripe_subscription_created) do
    # subscription_event

    {:ok, subscription_event} =
      %Kalda.Payments.SubscriptionEvent{user_id: user.id, name: name}
      |> Kalda.Payments.SubscriptionEvent.changeset(%{})
      |> Ecto.Changeset.force_change(:inserted_at, past_datetime())
      |> Ecto.Changeset.force_change(:updated_at, past_datetime())
      |> Kalda.Repo.insert()

    subscription_event
  end
end
