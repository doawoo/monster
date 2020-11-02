defmodule Monster.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Monster.Repo

  alias Monster.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
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
  def get_user(id), do: Repo.get(User, id)

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset_new_user(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @spec begin_email_change(integer, binary) :: :error | :ok
  def begin_email_change(user_id, desired_email) when is_integer(user_id) and is_binary(desired_email) do
    with %User{} = user <- get_user(user_id),
    {:ok, _updated_user} <- Repo.update(Ecto.Changeset.change(user, %{pending_email: desired_email})) do
      :ok
    else
      _ -> :error
    end
  end

  @spec commit_email_change(integer, binary) :: :error | :ok
  def commit_email_change(user_id, confirmed_email) when is_integer(user_id) and is_binary(confirmed_email) do
    with %User{} = user <- Repo.get_by(User, pending_email: confirmed_email, id: user_id),
    {:ok, _updated_user} <- Repo.update(Ecto.Changeset.change(user, %{email: user.pending_email, pending_email: nil})) do
      :ok
    else
      _ -> :error
    end
  end

  def change_user_password(user_id, current_password, new_password) when is_integer(user_id) and is_binary(current_password) and is_binary(new_password) do
    hashed_password = Bcrypt.hash_pwd_salt(new_password)
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    with %User{} = user <- get_user(user_id),
    true <- Bcrypt.verify_pass(current_password, user.password),
    {:ok, _password} <- NotQwerty123.PasswordStrength.strong_password?(new_password),
    {:ok, _updated_user} <- Repo.update(Ecto.Changeset.change(user, %{password: hashed_password, password_updated_at: now})) do
      :ok
    else
      {:error, _} = err -> err
      _ -> {:error, nil}
    end
  end

  def ban_user(user_id) do
    user = get_user!(user_id)
    Repo.update(Ecto.Changeset.change(user, %{banned: true}))
  end

  def unban_user(user_id) do
    user = get_user!(user_id)
    Repo.update(Ecto.Changeset.change(user, %{banned: false}))
  end
end
