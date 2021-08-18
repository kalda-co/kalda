defmodule Kalda.EmailLists do
  @moduledoc """
  The EmailLists context.
  """

  import Ecto.Query, warn: false
  require Logger
  alias Kalda.Repo

  alias Kalda.EmailLists.WaitlistSignup

  @doc """
  Returns the list of waitlist_signups.
  ## Examples
      iex> list_waitlist_signups()
      [%WaitlistSignup{}, ...]
  """
  def list_waitlist_signups do
    Repo.all(WaitlistSignup)
  end

  @doc """
  Makes a DELETE request to ALL sendfox contact lists!
  List IDs can be found in the list URLs. For example:
  https://sendfox.com/dashboard/lists/267383/contacts
  info logs warning if fails.
  Can be verified from localhost at the above list url in dev..

  ## Examples

    iex> unregister_with_sendfox(email, list_id)
    :ok

    iex> unregister_with_sendfox("", list_id)
    :error

  """
  def unregister_with_sendfox(email, list_id) do
    token = Application.get_env(:kalda, :sendfox_api_token)

    url =
      "https://api.sendfox.com/unsubscribe?" <>
        URI.encode_query(%{"email" => email, "lists[]" => list_id})

    headers = [Authorization: "Bearer #{token}", Accept: "application/json; charset=utf-8"]

    case HTTPoison.patch(url, "", headers) do
      {:ok, _response} ->
        Logger.info("Successfully removed user from Sendfox list #{list_id}")
        :ok

      {:error, reason} ->
        Logger.warn(
          "User #{email} could not be removed from Sendfox list #{list_id} because #{reason}"
        )

        :error
    end
  end

  @doc """
  Attempts to make a post request to the sendfox contact list
  List IDs can be found in the list URLs. For example:
  https://sendfox.com/dashboard/lists/267383/contacts
  info logs warning if fails.
  Can be verified from localhost at the above list url in dev..
  ## Examples
    iex> register_with_sendfox(email, list_id)
    :ok
    iex> register_with_sendfox("", list_id)
    :error
  """
  def register_with_sendfox(email, list_id) do
    token = Application.get_env(:kalda, :sendfox_api_token)

    url =
      "https://api.sendfox.com/contacts?" <>
        URI.encode_query(%{"email" => email, "lists[]" => list_id})

    headers = [Authorization: "Bearer #{token}", Accept: "application/json; charset=utf-8"]

    case HTTPoison.post(url, "", headers) do
      {:ok, _response} ->
        Logger.info("Successfully registered user with Sendfox list #{list_id}")
        :ok

      {:error, reason} ->
        Logger.warn(
          "User #{email} could not be registered to Sendfox list #{list_id}, because #{reason}"
        )

        :error
    end
  end

  @doc """
  Makes a post request to the sendfox contact list
  Raises exception if fails
  List IDs can be found in the list URLs. For example:
  https://sendfox.com/dashboard/lists/267383/contacts
  Can be verified from localhost at the above list url if in dev.
  ## Examples
    iex> register_with_sendfox!(email, list_id)
    :ok
    iex> register_with_sendfox!("", list_id)
    ** throws exception
  """
  def register_with_sendfox!(email, list_id) do
    token = Application.get_env(:kalda, :sendfox_api_token)

    url =
      "https://api.sendfox.com/contacts?" <>
        URI.encode_query(%{"email" => email, "lists[]" => list_id})

    headers = [Authorization: "Bearer #{token}", Accept: "application/json; charset=utf-8"]
    %{status_code: 200} = HTTPoison.post!(url, "", headers)
    Logger.info("Successfully registered user with Sendfox list #{list_id}")
    :ok
  end

  @doc """
  Gets a waitlist_signup or creates a new one for the email if it does not exist.
  ## Examples
      iex> create_waitlist_signup(%{field: value})
      {:ok, %WaitlistSignup{}}
      iex> create_waitlist_signup(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def get_or_create_waitlist_signup(email) do
    case get_waitlist_signup_by_email(email) do
      nil ->
        %WaitlistSignup{email: email}
        |> WaitlistSignup.changeset(%{})
        |> Repo.insert()

      waitlist_signup ->
        {:ok, waitlist_signup}
    end
  end

  def get_waitlist_signup_by_email(email) do
    case email do
      nil ->
        nil

      _ ->
        from(waitlist_signup in WaitlistSignup, where: waitlist_signup.email == ^email)
        |> Repo.one()
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking waitlist_signup changes.
  ## Examples
      iex> change_waitlist_signup(waitlist_signup)
      %Ecto.Changeset{data: %WaitlistSignup{}}
  """
  def change_waitlist_signup(%WaitlistSignup{} = waitlist_signup, attrs \\ %{}) do
    WaitlistSignup.changeset(waitlist_signup, attrs)
  end
end
