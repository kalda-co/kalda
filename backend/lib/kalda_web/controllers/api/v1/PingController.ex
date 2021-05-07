defmodule KaldaWeb.Api.V1.PingController do
  use KaldaWeb, :controller

  def show(conn, _params) do
    send_resp(conn, 200, "{\"message\":\"pong\"}")
  end
end
