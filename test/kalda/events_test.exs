defmodule Kalda.EventsTest do
  use Kalda.DataCase

  alias Kalda.Events
  alias Kalda.EventsFixtures

  describe "therapy_sessions" do
    alias Kalda.Events.TherapySession

    @valid_attrs %{starts_at: ~N[2010-04-17 14:00:00], link: "https://zoom.us"}
    @update_attrs %{starts_at: ~N[2011-05-18 15:01:01], link: "https://different-zoom.us"}
    @invalid_attrs %{starts_at: nil, link: nil}

    test "get_therapy_sessions/0 returns all future therapy_sessions" do
      therapy_session = EventsFixtures.future_therapy_session()
      assert Events.get_therapy_sessions() == [therapy_session]
    end

    test "get_therapy_sessions/1 returns limited future therapy_sessions" do
      therapy_session = EventsFixtures.future_therapy_session()

      therapy_session2 =
        EventsFixtures.future_therapy_session(%{starts_at: ~N[2230-05-18 09:00:00]})

      assert Events.get_therapy_sessions() == [therapy_session, therapy_session2]
    end

    test "get_therapy_sessions/0 returns no past therapy_sessions" do
      _past_therapy_session = EventsFixtures.past_therapy_session()
      _past_therapy_session = EventsFixtures.past_therapy_session()
      future_therapy_session = EventsFixtures.future_therapy_session()
      assert Events.get_therapy_sessions() == [future_therapy_session]
    end

    test "get_next_therapy_session!/1 returns the therapy_session with given id" do
      next_therapy_session = EventsFixtures.future_therapy_session()
      _past_therapy_session = EventsFixtures.past_therapy_session()

      _future_therapy_session =
        EventsFixtures.future_therapy_session(%{
          starts_at: NaiveDateTime.new!(~D[2030-01-01], ~T[00:00:00])
        })

      assert Events.get_next_therapy_session!() == next_therapy_session
    end

    test "get_therapy_session!/1 returns the therapy_session with given id" do
      therapy_session = EventsFixtures.future_therapy_session()
      assert Events.get_therapy_session!(therapy_session.id) == therapy_session
    end

    test "create_therapy_session/1 with valid data creates a therapy_session" do
      assert {:ok, %TherapySession{} = therapy_session} =
               Events.create_therapy_session(@valid_attrs)

      assert therapy_session.starts_at == ~N[2010-04-17 14:00:00]
      assert therapy_session.link == "https://zoom.us"
    end

    test "create_therapy_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_therapy_session(@invalid_attrs)
    end

    test "update_therapy_session/2 with valid data updates the therapy_session" do
      therapy_session = EventsFixtures.future_therapy_session()

      assert {:ok, %TherapySession{} = therapy_session} =
               Events.update_therapy_session(therapy_session, @update_attrs)

      assert therapy_session.starts_at == ~N[2011-05-18 15:01:01]
      assert therapy_session.link == "https://different-zoom.us"
    end

    test "update_therapy_session/2 with invalid data returns error changeset" do
      therapy_session = EventsFixtures.future_therapy_session()

      assert {:error, %Ecto.Changeset{}} =
               Events.update_therapy_session(therapy_session, @invalid_attrs)

      assert therapy_session == Events.get_therapy_session!(therapy_session.id)
    end

    test "delete_therapy_session/1 deletes the therapy_session" do
      therapy_session = EventsFixtures.future_therapy_session()
      assert {:ok, %TherapySession{}} = Events.delete_therapy_session(therapy_session)
      assert_raise Ecto.NoResultsError, fn -> Events.get_therapy_session!(therapy_session.id) end
    end

    test "change_therapy_session/1 returns a therapy_session changeset" do
      therapy_session = EventsFixtures.future_therapy_session()
      assert %Ecto.Changeset{} = Events.change_therapy_session(therapy_session)
    end
  end
end
