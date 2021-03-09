defmodule KaldaWeb.Api.V1.TherapyView do
  use KaldaWeb, :view
  alias Kalda.Events.TherapySession

  # TODO test json null
  def render_therapy_session(nil) do
    nil
  end

  def render_therapy_session(therapy_session = %TherapySession{}) do
    %{
      id: therapy_session.id,
      link: therapy_session.link,
      starts_at: therapy_session.starts_at,
      title: therapy_session.title,
      therapist: therapy_session.therapist,
      credentials: therapy_session.credentials,
      description: therapy_session.description
    }
  end
end
