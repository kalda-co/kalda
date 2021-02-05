defmodule KaldaWeb.Api.V1 do
  import Phoenix.Controller
  import Plug.Conn

  @spec handle_error({:error, :not_found} | {:error, Ecto.Changeset.t()} | Plug.Conn.t(), any) ::
          Plug.Conn.t()
  def handle_error(result, conn) do
    case result do
      conn = %Plug.Conn{} ->
        conn

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(KaldaWeb.ChangesetView)
        |> render("error.json", changeset: changeset)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> put_view(KaldaWeb.ErrorView)
        |> render(:"404")
    end
  end
end
