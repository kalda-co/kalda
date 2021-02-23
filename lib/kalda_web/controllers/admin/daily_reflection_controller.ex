defmodule KaldaWeb.Admin.DailyReflectionController do
  use KaldaWeb, :controller

  alias Kalda.Forums
  alias Kalda.Policy

  def index(conn, _params) do
    Policy.authorize!(conn, :view_admin_daily_reflections, Kalda)
    # TODO add pagination, do not get all users
    daily_reflections = Forums.get_daily_reflections()

    render(conn, "index.html", daily_reflections: daily_reflections)
  end

  def new(conn, _params) do
    Policy.authorize!(conn, :create_admin_daily_reflection, Kalda)
    changeset = Forums.change_daily_reflection(%Forums.Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"daily_reflection" => params}) do
    user = conn.assigns.current_user
    Policy.authorize!(conn, :create_admin_daily_reflection, Kalda)

    case Forums.create_daily_reflection(user, params) do
      {:ok, _daily_reflection} ->
        conn
        |> put_flash(:info, "Daily Reflection created successfully.")
        |> redirect(to: Routes.admin_daily_reflection_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    Policy.authorize!(conn, :view_admin_daily_reflection, Kalda)
    daily_reflection = Forums.get_post!(id)
    render(conn, "show.html", daily_reflection: daily_reflection)
  end

  def edit(conn, %{"id" => id}) do
    Policy.authorize!(conn, :edit_admin_daily_reflection, Kalda)
    daily_reflection = Forums.get_post!(id)
    changeset = Forums.change_daily_reflection(daily_reflection)
    render(conn, "edit.html", daily_reflection: daily_reflection, changeset: changeset)
  end

  def update(conn, %{"id" => id, "daily_reflection" => params}) do
    Policy.authorize!(conn, :edit_admin_daily_reflection, Kalda)
    daily_reflection = Forums.get_post!(id)

    case Forums.update_post(daily_reflection, params) do
      {:ok, daily_reflection} ->
        conn
        |> put_flash(:info, "Daily Reflection updated successfully.")
        |> redirect(to: Routes.admin_daily_reflection_path(conn, :show, daily_reflection))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", daily_reflection: daily_reflection, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    Policy.authorize!(conn, :delete_admin_daily_reflection, Kalda)
    daily_reflection = Forums.get_post!(id)
    {:ok, _daily_reflection} = Forums.delete_post(daily_reflection)

    conn
    |> put_flash(:info, "Daily Reflection deleted successfully.")
    |> redirect(to: Routes.admin_daily_reflection_path(conn, :index))
  end
end
