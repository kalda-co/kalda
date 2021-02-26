defmodule KaldaWeb.Api.V1.TherapyView do
  use KaldaWeb, :view
  alias Kalda.Events.TherapySession

  def render_therapy_session(therapy_session = %TherapySession{}) do
    %{
      id: therapy_session.id,
      link: therapy_session.link,
      event_datetime: therapy_session.event_datetime
    }
  end
end
