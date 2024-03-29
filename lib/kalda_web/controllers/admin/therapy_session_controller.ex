defmodule KaldaWeb.Admin.TherapySessionController do
  use KaldaWeb, :controller
  alias Kalda.Events.TherapySession
  alias Kalda.Events
  alias Kalda.Policy

  def index(conn, _params) do
    Policy.authorize!(conn, :view_therapy_session, Kalda)
    therapy_sessions = Events.get_therapy_sessions()
    render(conn, "index.html", therapy_sessions: therapy_sessions)
  end

  def new(conn, _params) do
    Policy.authorize!(conn, :create_therapy_session, Kalda)
    changeset = Events.change_therapy_session(%TherapySession{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"therapy_session" => params}) do
    Policy.authorize!(conn, :create_therapy_session, Kalda)

    case Events.create_therapy_session(params) do
      {:ok, _session} ->
        conn
        |> put_flash(:info, "Session created")
        |> redirect(to: Routes.admin_therapy_session_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(422)
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    Policy.authorize!(conn, :edit_admin_therapy_session, Kalda)
    therapy_session = Events.get_therapy_session!(id)
    changeset = Events.change_therapy_session(therapy_session)
    render(conn, "edit.html", therapy_session: therapy_session, changeset: changeset)
  end

  def update(conn, %{"id" => id, "therapy_session" => params}) do
    Policy.authorize!(conn, :edit_admin_therapy_session, Kalda)
    therapy_session = Events.get_therapy_session!(id)

    case Events.update_therapy_session(therapy_session, params) do
      {:ok, _therapy_session} ->
        conn
        |> put_flash(:info, "Therapy Session updated successfully.")
        |> redirect(to: Routes.admin_therapy_session_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", therapy_session: therapy_session, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    Policy.authorize!(conn, :delete_admin_therapy_session, Kalda)
    therapy_session = Events.get_therapy_session!(id)
    {:ok, _therapy_session} = Events.delete_therapy_session(therapy_session)

    conn
    |> put_flash(:info, "Daily Reflection deleted successfully.")
    |> redirect(to: Routes.admin_therapy_session_path(conn, :index))
  end
end
