defmodule KaldaWeb.Admin.DailyReflectionControllerTest do
  use KaldaWeb.ConnCase

  @create_daily_reflection_attrs %{content: "This is a daily reflection"}
  @update_daily_reflection_attrs %{content: "This is an updated daily reflection"}
  @schedule_daily_reflection_attrs %{
    content: "This is a daily reflection",
    published_at: "2030-01-23T23:50:07"
  }
  @invalid_daily_reflection_attrs %{content: ""}

  describe "index" do
    setup [:register_and_log_in_user]

    test "redirects if not admin", %{conn: conn} do
      conn = get(conn, Routes.admin_daily_reflection_path(conn, :index))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "index as admin" do
    setup [:register_and_log_in_admin]

    test "lists all daily reflections if admin", %{conn: conn} do
      conn = get(conn, Routes.admin_daily_reflection_path(conn, :index))
      assert html_response(conn, 200) =~ "Daily Reflections"
    end
  end

  describe "new daily reflection" do
    setup [:register_and_log_in_user]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_daily_reflection_path(conn, :new))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "new daily reflection as admin" do
    setup [:register_and_log_in_admin]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_daily_reflection_path(conn, :new))
      assert html_response(conn, 200) =~ "New Daily Reflection"
    end
  end

  describe "create daily reflection" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn} do
      conn =
        post(conn, Routes.admin_daily_reflection_path(conn, :create),
          daily_reflection: @create_daily_reflection_attrs
        )

      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "create daily reflection as admin" do
    setup [:register_and_log_in_admin]

    test "redirects to index when data is valid and user is admin", %{conn: conn} do
      conn =
        post(conn, Routes.admin_daily_reflection_path(conn, :create),
          daily_reflection: @create_daily_reflection_attrs
        )

      assert redirected_to(conn) == Routes.admin_daily_reflection_path(conn, :index)

      conn = get(conn, Routes.admin_daily_reflection_path(conn, :index))
      assert html_response(conn, 200) =~ "Daily Reflections"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.admin_daily_reflection_path(conn, :create),
          daily_reflection: @invalid_daily_reflection_attrs
        )

      response = html_response(conn, 200)
      assert response =~ "Please check the errors below"
    end
  end

  describe "edit daily reflection" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn, user: user} do
      daily_reflection = Kalda.ForumsFixtures.post(user, @create_daily_reflection_attrs)
      conn = get(conn, Routes.admin_daily_reflection_path(conn, :edit, daily_reflection))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "edit daily reflection as admin" do
    setup [:register_and_log_in_admin]

    test "renders form for editing chosen daily reflection", %{conn: conn, user: user} do
      daily_reflection = Kalda.ForumsFixtures.post(user, @create_daily_reflection_attrs)
      conn = get(conn, Routes.admin_daily_reflection_path(conn, :edit, daily_reflection))
      assert html_response(conn, 200) =~ "Edit Daily Reflection"
    end
  end

  describe "schedule daily reflection" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn, user: user} do
      daily_reflection = Kalda.ForumsFixtures.post(user, @schedule_daily_reflection_attrs)
      conn = get(conn, Routes.admin_daily_reflection_path(conn, :edit, daily_reflection))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "schedule daily reflection as admin" do
    setup [:register_and_log_in_admin]

    test "renders form for editing chosen daily reflection", %{conn: conn, user: user} do
      daily_reflection = Kalda.ForumsFixtures.post(user, @schedule_daily_reflection_attrs)
      conn = get(conn, Routes.admin_daily_reflection_path(conn, :edit, daily_reflection))
      assert html_response(conn, 200) =~ "Edit Daily Reflection"
    end
  end

  describe "update daily reflection" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn, user: user} do
      daily_reflection = Kalda.ForumsFixtures.post(user, @create_daily_reflection_attrs)

      conn =
        put(conn, Routes.admin_daily_reflection_path(conn, :update, daily_reflection),
          daily_reflection: @update_daily_reflection_attrs
        )

      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "update daily reflection as admin" do
    setup [:register_and_log_in_admin]

    test "renders form for editing chosen daily reflection", %{conn: conn, user: user} do
      daily_reflection = Kalda.ForumsFixtures.post(user, @create_daily_reflection_attrs)

      conn =
        put(conn, Routes.admin_daily_reflection_path(conn, :update, daily_reflection),
          daily_reflection: @update_daily_reflection_attrs
        )

      assert redirected_to(conn) ==
               Routes.admin_daily_reflection_path(conn, :show, daily_reflection)

      conn = get(conn, Routes.admin_daily_reflection_path(conn, :show, daily_reflection))
      assert html_response(conn, 200) =~ "This is an updated daily reflection"
    end
  end

  describe "delete daily reflection" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn, user: user} do
      daily_reflection = Kalda.ForumsFixtures.post(user)

      conn = delete(conn, Routes.admin_daily_reflection_path(conn, :delete, daily_reflection))

      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "delete daily reflection as admin" do
    setup [:register_and_log_in_admin]

    test "renders form for editing chosen daily reflection", %{conn: conn, user: user} do
      daily_reflection = Kalda.ForumsFixtures.post(user)

      conn = delete(conn, Routes.admin_daily_reflection_path(conn, :delete, daily_reflection))

      assert redirected_to(conn) ==
               Routes.admin_daily_reflection_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_daily_reflection_path(conn, :show, daily_reflection))
      end
    end
  end
end
