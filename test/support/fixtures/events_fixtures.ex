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
      link: "https://somerandomlink",
      event_datetime: future_datetime()
    }

    attrs = Map.merge(defaults, attrs)

    {:ok, sesh} = Kalda.Events.create_therapy_session(attrs)
    sesh
  end

  def past_therapy_session(attrs \\ %{}) do
    defaults = %{
      link: "https://somerandomlink",
      event_datetime: past_datetime()
    }

    attrs = Map.merge(defaults, attrs)

    {:ok, sesh} = Kalda.Events.create_therapy_session(attrs)
    sesh
  end
end
