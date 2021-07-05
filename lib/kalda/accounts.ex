defmodule Kalda.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Kalda.Repo
  alias Kalda.Accounts.{User, UserToken, UserNotifier, Invite, ReferralLink}

  ## Database getters

  @doc """
  Gets users

  ## Examples

      iex> get_users()
      [%User{}, ...]

      iex> get_users()
      []

  """
  # TODO add pagination to this request - get 50 at a time perhaps, sort by date
  def get_users(opts \\ []) do
    preload = opts[:preload] || []
    Repo.all(from user in User, preload: ^preload)
  end

  @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a user by email and password.

  ## Examples

      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password), do: user
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  ## User registration

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs) do
    %User{has_free_subscription: true}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_registration(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs, hash_password: false)
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user email.

  ## Examples

      iex> change_user_email(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_email(user, attrs \\ %{}) do
    User.email_changeset(user, attrs)
  end

  @doc """
  Emulates that the email will change without actually changing
  it in the database.

  ## Examples

      iex> apply_user_email(user, "valid password", %{email: ...})
      {:ok, %User{}}

      iex> apply_user_email(user, "invalid password", %{email: ...})
      {:error, %Ecto.Changeset{}}

  """
  def apply_user_email(user, password, attrs) do
    user
    |> User.email_changeset(attrs)
    |> User.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the user email using the given token.

  If the token matches, the user email is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  def update_user_email(user, token) do
    context = "change:#{user.email}"

    with {:ok, query} <- UserToken.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(user_email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_email_multi(user, email, context) do
    changeset = user |> User.email_changeset(%{email: email}) |> User.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, [context]))
  end

  @doc """
  Delivers the update email instructions to the given user.

  ## Examples

      iex> deliver_update_email_instructions(user, current_email, &Routes.user_update_email_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_update_email_instructions(%User{} = user, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "change:#{current_email}")

    Repo.insert!(user_token)
    UserNotifier.deliver_update_email_instructions(user, update_email_url_fun.(encoded_token))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user password.

  ## Examples

      iex> change_user_password(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_password(user, attrs \\ %{}) do
    User.password_changeset(user, attrs, hash_password: false)
  end

  @doc """
  Updates the user password.

  ## Examples

      iex> update_user_password(user, "valid password", %{password: ...})
      {:ok, %User{}}

      iex> update_user_password(user, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_password(user, password, attrs) do
    changeset =
      user
      |> User.password_changeset(attrs)
      |> User.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Generates an API authentication token.
  """
  def generate_api_auth_token(user) do
    {token, user_token} = UserToken.build_api_auth_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given API session token.
  """
  def get_user_by_api_auth_token(token) do
    case UserToken.verify_api_auth_token(token) do
      {:ok, query} -> Repo.one(query)
      _ -> nil
    end
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    :ok
  end

  ## Confirmation

  @doc """
  Delivers the confirmation email instructions to the given user.

  ## Examples

      iex> deliver_user_confirmation_instructions(user, &Routes.user_confirmation_url(conn, :confirm, &1))
      {:ok, %{to: ..., body: ...}}

      iex> deliver_user_confirmation_instructions(confirmed_user, &Routes.user_confirmation_url(conn, :confirm, &1))
      {:error, :already_confirmed}

  """
  def deliver_user_confirmation_instructions(%User{} = user, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    if user.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, user_token} = UserToken.build_email_token(user, "confirm")
      Repo.insert!(user_token)
      UserNotifier.deliver_confirmation_instructions(user, confirmation_url_fun.(encoded_token))
    end
  end

  @doc """
  Confirms a user by the given token.

  If the token matches, the user account is marked as confirmed
  and the token is deleted.
  """
  def confirm_user(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "confirm"),
         %User{} = user <- Repo.one(query),
         {:ok, %{user: user}} <- Repo.transaction(confirm_user_multi(user)) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  defp confirm_user_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, ["confirm"]))
  end

  ## Reset password

  @doc """
  Delivers the reset password email to the given user.

  ## Examples

      iex> deliver_user_reset_password_instructions(user, &Routes.user_reset_password_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_user_reset_password_instructions(%User{} = user, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "reset_password")
    Repo.insert!(user_token)
    UserNotifier.deliver_reset_password_instructions(user, reset_password_url_fun.(encoded_token))
  end

  @doc """
  Gets the user by reset password token.

  ## Examples

      iex> get_user_by_reset_password_token("validtoken")
      %User{}

      iex> get_user_by_reset_password_token("invalidtoken")
      nil

  """
  def get_user_by_reset_password_token(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "reset_password"),
         %User{} = user <- Repo.one(query) do
      user
    else
      _ -> nil
    end
  end

  @doc """
  Resets the user password.

  ## Examples

      iex> reset_user_password(user, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %User{}}

      iex> reset_user_password(user, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  def reset_user_password(user, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.password_changeset(user, attrs))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  ##############
  # Invites
  ##############

  @token_validity_in_days 30

  # This checks if the token exists AND has not already been used to creat a user
  def get_invite_for_token(token) do
    case Kalda.Accounts.Invite.hash_token(token) do
      {:ok, hashed_token} ->
        Repo.one(
          from i in Kalda.Accounts.Invite,
            left_join: u in User,
            on: i.invitee_email == u.email,
            where: is_nil(u),
            where: i.token == ^hashed_token,
            where: i.inserted_at > ago(@token_validity_in_days, "day"),
            select: i
        )

      :error ->
        :error
    end
  end

  def create_user_from_invite(token, attrs) do
    # This also checks if there is already a user
    case get_invite_for_token(token) do
      %Invite{invitee_email: email} ->
        now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

        %User{email: email, confirmed_at: now}
        |> User.registration_changeset(attrs)
        |> Repo.insert()

      _ ->
        :not_found
    end
  end

  def create_invite(email) do
    %{token: token, changeset: changeset} = Invite.build_invite(email)

    case Repo.insert(changeset) do
      {:ok, invite} ->
        {:ok, {token, invite}}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  ##############
  # ReferralLinks
  ##############

  @doc """
  Creates a referral_link for a user

  ## Examples

      iex> create_referral(user, %{field: value})
      {:ok, %ReferralLink{}}

      iex> create_referral(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_referral(user, attrs \\ %{}) do
    %ReferralLink{owner_id: user.id}
    |> ReferralLink.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_from_referral(name, attrs) do
    # TODO check this creates unconfirmed user and sends email confirmation instructions
    # Transaction that also deprecates referral_link_slots and checks expirey? Or do that part in controller? (purobably do in both)
    case get_referral_link_by_name(name) do
      %ReferralLink{} = referral_link ->
        referral_link_transaction(referral_link, attrs)

      _ ->
        # Get referral_link by name won't get expired or zero-slots so this will be returned
        :not_found
    end
  end

  defp referral_link_transaction(referral_link, attrs) do
    case Timex.after?(referral_link.expires_at, NaiveDateTime.local_now()) &&
           referral_link.referring_slots > 0 do
      true ->
        slots = referral_link.referring_slots
        new_slots = slots - 1
        changeset = referral_link |> ReferralLink.changeset(%{referring_slots: new_slots})

        Ecto.Multi.new()
        |> Ecto.Multi.insert(
          :user,
          User.registration_changeset(%User{referred_by: referral_link.id}, attrs)
        )
        |> Ecto.Multi.update(:referral_link, changeset)
        |> Repo.transaction()
        |> case do
          {:ok, %{user: user}} -> {:ok, user}
          {:error, :user, changeset, _} -> {:error, changeset}
        end

      _ ->
        :expired
    end
  end

  # TODO: do we need to add `when is_binary(name)`
  def get_referral_link_by_name(referral_link_name) do
    now = NaiveDateTime.local_now()

    Repo.one(
      from r in Kalda.Accounts.ReferralLink,
        where: r.name == ^referral_link_name,
        where: r.expires_at > ^now,
        where: r.referring_slots > 0,
        select: r
    )
  end

  # TODO test and order by expired/valid. Have a way to edit the referral_links so that expired ones can be renamed? so name can be reused?
  def get_referrals(opts \\ []) do
    preload = opts[:preload] || []

    Repo.all(
      from referral_link in ReferralLink,
        order_by: [desc: referral_link.expires_at],
        preload: ^preload
    )
  end

  @doc """
  Gets a single referral_link.

  Raises `Ecto.NoResultsError` if the ReferralLink does not exist.

  ## Examples

      iex> get_referral!(123, opts || [])
      %ReferralLink{}

      iex> get_referral!(456), opts || []
      ** (Ecto.NoResultsError)

  """
  def get_referral!(id, opts \\ []) do
    preload = opts[:preload] || []

    from(referral_link in ReferralLink,
      where: referral_link.id == ^id,
      preload: ^preload
    )
    |> Repo.get!(id)
  end

  #############
  # Subscriptions
  ##############

  def add_stripe_subscription(%User{} = user) do
    user
    |> Ecto.Changeset.change(has_stripe_subscription: true)
    |> Repo.update!()

    IO.inspect(user)
    user
  end

  def remove_stripe_subscription(%User{} = user) do
    user
    |> Ecto.Changeset.change(has_stripe_subscription: false)
    |> Repo.update!()

    user
  end

  def add_free_subscription(%User{} = user) do
    user
    |> Ecto.Changeset.change(has_free_subscription: true)
    |> Repo.update!()

    user
  end

  def remove_free_subscription(%User{} = user) do
    user
    |> Ecto.Changeset.change(has_free_subscription: false)
    |> Repo.update!()

    user
  end

  def has_subscription?(%User{} = user) do
    if user.has_free_subscription || user.has_stripe_subscription do
      true
    else
      false
    end
  end
end
