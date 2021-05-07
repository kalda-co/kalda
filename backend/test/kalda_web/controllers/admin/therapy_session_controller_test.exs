defmodule KaldaWeb.Admin.TherapySessionControllerTest do
  use KaldaWeb.ConnCase

  @create_therapy_session_attrs %{
    starts_at: "2030-01-23T23:50:07",
    link: "https://zoom.us"
  }
  @update_therapy_session_attrs %{
    starts_at: "2030-01-23T23:50:07",
    link: "https://zoom/updated.us"
  }
  @invalid_therapy_session_attrs %{
    starts_at: "2030-01-23T23:50:07",
    link: ""
  }

  describe "index" do
    setup [:register_and_log_in_user]

    test "redirects if not admin", %{conn: conn} do
      conn = get(conn, Routes.admin_therapy_session_path(conn, :index))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "index as admin" do
    setup [:register_and_log_in_admin]

    test "lists all sessions if admin", %{conn: conn} do
      conn = get(conn, Routes.admin_therapy_session_path(conn, :index))
      assert html_response(conn, 200) =~ "Therapy Sessions"
    end
  end

  describe "new  therapy sesssion" do
    setup [:register_and_log_in_user]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_therapy_session_path(conn, :new))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "new therapy_session as admin" do
    setup [:register_and_log_in_admin]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_therapy_session_path(conn, :new))
      assert html_response(conn, 200) =~ "New Therapy Session"
    end
  end

  describe "create therapy_session" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn} do
      conn =
        post(conn, Routes.admin_therapy_session_path(conn, :create),
          therapy_session: @create_therapy_session_attrs
        )

      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "create therapy_session as admin" do
    setup [:register_and_log_in_admin]

    test "redirects to index when data is valid and user is admin", %{conn: conn} do
      conn =
        post(conn, Routes.admin_therapy_session_path(conn, :create),
          therapy_session: @create_therapy_session_attrs
        )

      assert redirected_to(conn) == Routes.admin_therapy_session_path(conn, :index)

      conn = get(conn, Routes.admin_therapy_session_path(conn, :index))
      assert html_response(conn, 200) =~ "Therapy Sessions"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.admin_therapy_session_path(conn, :create),
          therapy_session: @invalid_therapy_session_attrs
        )

      response = html_response(conn, 422)
      assert response =~ "Please check the errors below"
    end
  end

  describe "edit therapy session" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn} do
      therapy_session = Kalda.EventsFixtures.future_therapy_session()

      conn = get(conn, Routes.admin_therapy_session_path(conn, :edit, therapy_session))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "edit therapy_session as admin" do
    setup [:register_and_log_in_admin]

    test "renders form for editing chosen therapy_session", %{conn: conn} do
      assert therapy_session = Kalda.EventsFixtures.future_therapy_session()

      conn = get(conn, Routes.admin_therapy_session_path(conn, :edit, therapy_session))
      assert html_response(conn, 200) =~ "Edit therapy session"
    end
  end

  describe "schedule therapy_session" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn} do
      therapy_session = Kalda.EventsFixtures.future_therapy_session(@create_therapy_session_attrs)

      conn = get(conn, Routes.admin_therapy_session_path(conn, :edit, therapy_session))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "schedule therapy_session as admin" do
    setup [:register_and_log_in_admin]

    test "renders form for editing chosen therapy_session", %{conn: conn} do
      assert therapy_session =
               Kalda.EventsFixtures.future_therapy_session(@create_therapy_session_attrs)

      conn = get(conn, Routes.admin_therapy_session_path(conn, :edit, therapy_session))
      assert html_response(conn, 200) =~ "Edit therapy session"
    end
  end

  describe "update therapy_session" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn} do
      therapy_session = Kalda.EventsFixtures.future_therapy_session(@create_therapy_session_attrs)

      conn =
        put(conn, Routes.admin_therapy_session_path(conn, :update, therapy_session),
          therapy_session: @update_therapy_session_attrs
        )

      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "update therapy_session as admin" do
    setup [:register_and_log_in_admin]

    test "renders form for editing chosen therapy_session", %{conn: conn} do
      therapy_session = Kalda.EventsFixtures.future_therapy_session()

      conn =
        put(conn, Routes.admin_therapy_session_path(conn, :update, therapy_session),
          therapy_session: @update_therapy_session_attrs
        )

      assert redirected_to(conn) ==
               Routes.admin_therapy_session_path(conn, :index)

      conn = get(conn, Routes.admin_therapy_session_path(conn, :index))
      assert html_response(conn, 200) =~ "https://zoom/updated.us"
    end
  end

  describe "delete therapy_session" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn} do
      therapy_session = Kalda.EventsFixtures.future_therapy_session()

      conn = delete(conn, Routes.admin_therapy_session_path(conn, :delete, therapy_session))

      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "delete therapy_session as admin" do
    setup [:register_and_log_in_admin]

    test "deletes therapy_session", %{conn: conn} do
      _not_deleted_therapy_session =
        Kalda.EventsFixtures.future_therapy_session(@create_therapy_session_attrs)

      therapy_session = Kalda.EventsFixtures.future_therapy_session(@update_therapy_session_attrs)

      conn = delete(conn, Routes.admin_therapy_session_path(conn, :delete, therapy_session))

      assert redirected_to(conn) ==
               Routes.admin_therapy_session_path(conn, :index)

      conn = get(conn, Routes.admin_therapy_session_path(conn, :index))
      refute html_response(conn, 200) =~ "https://zoom/updated.us"
      assert html_response(conn, 200) =~ "https://zoom.us"
      # refute Kalda.Admin.list_archived() == []
    end
  end
end
