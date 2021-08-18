defmodule Kalda.EmailLists do
  @moduledoc """
  The EmailLists context.
  """

  import Ecto.Query, warn: false
  require Logger
  alias Kalda.Repo

  alias Kalda.EmailLists.Signup

  @doc """
  Returns the list of signups.
  ## Examples
      iex> list_signups()
      [%Signup{}, ...]
  """
  def list_signups do
    default = "waitlist_56109"

    Repo.all(
      from s in Signup,
        where: s.list == ^default
    )
  end

  @doc """
  Makes a DELETE request to ALL sendfox contact lists!
  info logs warning if fails.
  Can be verified from localhost at the above list url in dev..

  ## Examples

    iex> unregister_with_sendfox(email)
    :ok

    iex> unregister_with_sendfox("")
    :error

  """
  def unregister_with_sendfox(email) do
    token = Application.get_env(:kalda, :sendfox_api_token)

    url =
      "https://api.sendfox.com/unsubscribe?" <>
        URI.encode_query(%{"email" => email})

    headers = [Authorization: "Bearer #{token}", Accept: "application/json; charset=utf-8"]

    case HTTPoison.patch(url, "", headers) do
      {:ok, %{status_code: 200}} ->
        Logger.info("Successfully removed user from Sendfox")
        :ok

      reason ->
        Logger.error("User #{email} could not be removed from Sendfox because #{inspect(reason)}")

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
      {:ok, %{status_code: 200}} ->
        Logger.info("Successfully registered user with Sendfox list #{list_id}")
        :ok

      result ->
        Logger.error(
          "User #{email} could not be registered to Sendfox list #{list_id}, because #{
            inspect(result)
          }"
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
  Gets a signup or creates a new one for the email if it does not exist.
  Uses default list = waitlist_56109
  ## Examples
      iex> create_signup(%{field: value})
      {:ok, %Signup{}}
      iex> create_signup(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def get_or_create_signup(email) do
    case get_signup_by_email(email) do
      nil ->
        %Signup{email: email}
        |> Signup.changeset(%{})
        |> Repo.insert()

      signup ->
        {:ok, signup}
    end
  end

  def get_signup_by_email(email) do
    case email do
      nil ->
        nil

      _ ->
        from(signup in Signup, where: signup.email == ^email)
        |> Repo.one()
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking signup changes.
  ## Examples
      iex> change_signup(signup)
      %Ecto.Changeset{data: %Signup{}}
  """
  def change_signup(%Signup{} = signup, attrs \\ %{}) do
    Signup.changeset(signup, attrs)
  end
end
