defmodule Kalda.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Kalda.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"
  def unique_username, do: "u_n#{System.unique_integer()}"

  def user(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        username: unique_username(),
        email: unique_user_email(),
        password: valid_user_password()
      })
      |> Kalda.Accounts.register_user()

    user
  end

  def admin(attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        username: unique_username(),
        email: "admin#{System.unique_integer()}@example.com",
        password: valid_user_password()
      })

    {:ok, user} =
      %Kalda.Accounts.User{is_admin: true}
      |> Kalda.Accounts.User.registration_changeset(attrs)
      |> Kalda.Repo.insert()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.body, "[TOKEN]")
    token
  end
end
