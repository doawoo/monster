defmodule Monster.Tokens do
  @moduledoc """
  The Tokens context.
  """

  import Ecto.Query, warn: false
  alias Monster.Repo

  alias Monster.Tokens.RevokedToken

  @doc """
  Returns the list of revoked_tokens.

  ## Examples

      iex> list_revoked_tokens()
      [%RevokedToken{}, ...]

  """
  def list_revoked_tokens do
    Repo.all(RevokedToken)
  end

  @doc """
  Gets a single revoked_token.

  Raises `Ecto.NoResultsError` if the Revoked token does not exist.

  ## Examples

      iex> get_revoked_token!(123)
      %RevokedToken{}

      iex> get_revoked_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_revoked_token!(id), do: Repo.get!(RevokedToken, id)

  @doc """
  Creates a revoked_token.

  ## Examples

      iex> create_revoked_token(%{field: value})
      {:ok, %RevokedToken{}}

      iex> create_revoked_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_revoked_token(attrs \\ %{}) do
    %RevokedToken{}
    |> RevokedToken.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a revoked_token.

  ## Examples

      iex> update_revoked_token(revoked_token, %{field: new_value})
      {:ok, %RevokedToken{}}

      iex> update_revoked_token(revoked_token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_revoked_token(%RevokedToken{} = revoked_token, attrs) do
    revoked_token
    |> RevokedToken.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a revoked_token.

  ## Examples

      iex> delete_revoked_token(revoked_token)
      {:ok, %RevokedToken{}}

      iex> delete_revoked_token(revoked_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_revoked_token(%RevokedToken{} = revoked_token) do
    Repo.delete(revoked_token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking revoked_token changes.

  ## Examples

      iex> change_revoked_token(revoked_token)
      %Ecto.Changeset{data: %RevokedToken{}}

  """
  def change_revoked_token(%RevokedToken{} = revoked_token, attrs \\ %{}) do
    RevokedToken.changeset(revoked_token, attrs)
  end
end
