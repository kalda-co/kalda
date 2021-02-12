defmodule KaldaWeb.Admin.CommentController do
  use KaldaWeb, :controller

  alias Kalda.Forums
  alias Kalda.Policy

  def index(conn, _params) do
    Policy.authorize!(conn, :view_admin_comments, Kalda)
    # TODO add pagination, do not get all users
    comments = Forums.get_comments(preload: [:author, replies: [:author, replies: [:author]]])

    render(conn, "index.html", comments: comments)
  end

  def new(conn, _params) do
    Policy.authorize!(conn, :create_admin_comment, Kalda)
    changeset = Forums.change_comment(%Forums.Comment{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"comment" => params}) do
    user = conn.assigns.current_user
    Policy.authorize!(conn, :create_admin_comment, Kalda)

    case Forums.create_comment(user, params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.admin_post_comment_path(conn, :show, comment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    Policy.authorize!(conn, :view_admin_comment, Kalda)
    comment = Forums.get_comment!(id)
    render(conn, "show.html", comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    Policy.authorize!(conn, :edit_admin_comment, Kalda)
    comment = Forums.get_comment!(id)
    changeset = Forums.change_comment(comment)
    render(conn, "edit.html", comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => params}) do
    Policy.authorize!(conn, :edit_admin_comment, Kalda)
    comment = Forums.get_comment!(id)

    case Forums.update_comment(comment, params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: Routes.admin_post_comment_path(conn, :show, comment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    Policy.authorize!(conn, :delete_admin_comment, Kalda)
    comment = Forums.get_comment!(id)
    {:ok, comment} = Forums.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.admin_post_comment_path(conn, comment.post_id, :index))
  end
end
