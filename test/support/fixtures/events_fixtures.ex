defmodule Kalda.EventsFixtures do
  def future_datetime() do
    now = NaiveDateTime.local_now()
    NaiveDateTime.add(now, 36000)
  end

  def past_datetime() do
    now = NaiveDateTime.local_now()
    NaiveDateTime.add(now, -96000)
  end

  def future_therapy_session(attrs \\ %{}) do
    defaults = %{
      title: "Mindfulness",
      description: "How to get still and present and reduce anxiety",
      therapist: "Al Dee",
      credentials: "FreeMind hypnotherapist and mindfulness coach",
      link: "https://somerandomlink.co",
      starts_at: future_datetime()
    }

    attrs = Map.merge(defaults, attrs)

    {:ok, sesh} = Kalda.Events.create_therapy_session(attrs)
    sesh
  end

  def past_therapy_session(attrs \\ %{}) do
    defaults = %{
      title: "Mindfulness",
      description: "How to get still and present and reduce anxiety",
      therapist: "Al Dee",
      credentials: "FreeMind hypnotherapist and mindfulness coach",
      link: "https://somerandomlink.co",
      starts_at: past_datetime()
    }

    attrs = Map.merge(defaults, attrs)

    {:ok, sesh} = Kalda.Events.create_therapy_session(attrs)
    sesh
  end
end
