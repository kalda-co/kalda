defmodule KaldaWeb.Errors do
  @filtered_params ["password", "password_confirmation"]

  def handle_errors(conn, %{kind: kind, reason: reason, stack: stacktrace}) do
    occurrence_data = %{
      "request" => %{
        "cookies" => conn.req_cookies,
        "url" => "#{conn.scheme}://#{conn.host}:#{conn.port}#{conn.request_path}",
        "user_ip" => List.to_string(:inet.ntoa(conn.remote_ip)),
        "headers" => Enum.into(conn.req_headers, %{}),
        "method" => conn.method,
        "params" => get_sanitised_params(conn)
      },
      "server" => %{}
    }

    Rollbax.report(kind, reason, stacktrace, _custom_data = %{}, occurrence_data)
  end

  defp get_sanitised_params(conn) do
    conn =
      conn
      |> Plug.Conn.fetch_cookies()
      |> Plug.Conn.fetch_query_params()

    case conn.params do
      %Plug.Conn.Unfetched{} -> "unfetched"
      params -> sanitise(params)
    end
  end

  @doc """
  Filter sensitive information out.

  # Examples

      iex> sanitise(%{})
      %{}

      iex> sanitise(nil)
      nil

      iex> sanitise(%{"hello" => "world"})
      %{"hello" => "world"}

      iex> sanitise(%{"password" => "thisisademopassword"})
      %{"password" => "[FILTERED]"}

      iex> sanitise(%{"user" => %{"password" => "thisisademopassword"}})
      %{"user" => %{"password" => "[FILTERED]"}}
  """
  def sanitise(params) when is_map(params) do
    for {key, value} <- params, into: %{} do
      if key in @filtered_params do
        {key, "[FILTERED]"}
      else
        {key, sanitise(value)}
      end
    end
  end

  def sanitise(params) do
    params
  end
end
