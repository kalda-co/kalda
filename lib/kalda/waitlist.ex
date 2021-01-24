defmodule Kalda.Waitlist do
  @moduledoc """
  The Waitlist context.
  """

  import Ecto.Query, warn: false
  require Logger
  alias Kalda.Repo

  alias Kalda.Waitlist.Signup

  @doc """
  Returns the list of signups.
  ## Examples
      iex> list_signups()
      [%Signup{}, ...]
  """
  def list_signups do
    Repo.all(Signup)
  end

  @doc """
  Makes a post request to the sendfox contact list (Waitlist Newsletter)
  Raises exception if fails
  ## Examples
    iex> sendfox_post_request(email)
    :ok
    iex> sendfox_post_request("")
    ** throws exception
  """
  def sendfox_post_request!(email) do
    list_id = Application.get_env(:kalda, :sendfox_list_id)
    token = Application.get_env(:kalda, :sendfox_api_token)

    # This is hardcoded to the list 'Waitlist Newsletter'
    url =
      "https://api.sendfox.com/contacts?" <>
        URI.encode_query(%{"email" => email, "lists[]" => list_id})

    headers = [Authorization: "Bearer #{token}", Accept: "application/json; charset=utf-8"]
    %{status_code: 200} = HTTPoison.post!(url, "", headers)
    Logger.info("Successfully registered user with Sendfox list #{list_id}")
    :ok
  end

  @doc """
  Creates a signup.
  ## Examples
      iex> create_signup(%{field: value})
      {:ok, %Signup{}}
      iex> create_signup(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_signup(attrs \\ %{}) do
    case get_signup_by_email(attrs["email"]) do
      nil ->
        %Signup{}
        |> Signup.changeset(attrs)
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
