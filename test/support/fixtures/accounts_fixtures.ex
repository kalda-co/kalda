defmodule Kalda.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Kalda.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"
  def unique_username, do: "u_n#{System.unique_integer()}"
  def unique_name, do: "name#{System.unique_integer()}"

  def user(attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        username: unique_username(),
        email: "admin#{System.unique_integer()}@example.com",
        password: valid_user_password()
      })

    {:ok, user} =
      %Kalda.Accounts.User{
        is_admin: false,
        confirmed_at: NaiveDateTime.local_now() |> NaiveDateTime.add(-1),
        stripe_customer_id: attrs[:stripe_customer_id]
      }
      |> Kalda.Accounts.User.registration_changeset(attrs)
      |> Kalda.Repo.insert()

    user
  end

  def unconfirmed_user(attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        username: unique_username(),
        email: "admin#{System.unique_integer()}@example.com",
        password: valid_user_password()
      })

    {:ok, user} =
      %Kalda.Accounts.User{}
      |> Kalda.Accounts.User.registration_changeset(attrs)
      |> Kalda.Repo.insert()

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
      %Kalda.Accounts.User{is_admin: true, confirmed_at: NaiveDateTime.local_now()}
      |> Kalda.Accounts.User.registration_changeset(attrs)
      |> Kalda.Repo.insert()

    user
  end

  @doc """
  Returns a user fixture with a subcription of type :free or :paid
  by passing in type as atom :free or atom :stripe

  ## Examples
      iex> user_with_subscription(:free)
      %User{has_free_subscription: true}

      iex> user_with_subscription(:stripe)
      %User{has_stripe_subscription: true}

  """
  def user_with_subscription(type, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        username: unique_username(),
        email: "admin#{System.unique_integer()}@example.com",
        password: valid_user_password()
      })

    case type do
      :stripe ->
        {:ok, user} =
          %Kalda.Accounts.User{
            has_stripe_subscription: true,
            confirmed_at: NaiveDateTime.local_now()
          }
          |> Kalda.Accounts.User.registration_changeset(attrs)
          |> Kalda.Repo.insert()

        user

      :free ->
        {:ok, user} =
          %Kalda.Accounts.User{
            has_free_subscription: true,
            confirmed_at: NaiveDateTime.local_now()
          }
          |> Kalda.Accounts.User.registration_changeset(attrs)
          |> Kalda.Repo.insert()

        user
    end
  end

  def extract_user_token(fun) do
    %Bamboo.Email{} = captured = fun.(&"[TOKEN]#{&1}[TOKEN]")

    [_, token, _] = String.split(captured.text_body, "[TOKEN]")
    token
  end

  def invite(email \\ "example@example.com") do
    {:ok, {a, b}} = Kalda.Accounts.create_invite(email)
    {a, b}
  end

  def expired_invite(email \\ "example@example.com") do
    {:ok, {token, inv}} = Kalda.Accounts.create_invite(email)

    {1, nil} =
      Kalda.Repo.update_all(Kalda.Accounts.Invite, set: [inserted_at: ~N[2020-01-01 00:00:00]])

    {token, inv}
  end

  def referral_link(owner = %Kalda.Accounts.User{}, attrs \\ %{}) do
    defaults = %{
      name: unique_name(),
      # Two weeks from now
      expires_at: NaiveDateTime.add(NaiveDateTime.local_now(), 14 * 24 * 60 * 60, :second)
    }

    attrs = Map.merge(defaults, attrs)
    {:ok, referral_link} = Kalda.Accounts.create_referral(owner, attrs)
    referral_link
  end

  def expired_referral(
        owner = %Kalda.Accounts.User{},
        attrs \\ %{}
      ) do
    defaults = %{
      name: unique_name(),
      expires_at: NaiveDateTime.add(NaiveDateTime.local_now(), -1, :second)
    }

    attrs = Map.merge(defaults, attrs)
    referral_link(owner, attrs)
  end
end
