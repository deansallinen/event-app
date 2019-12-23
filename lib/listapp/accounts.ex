defmodule Listapp.Accounts do

  import Ecto.Query, warn: false
  alias Listapp.Repo

  alias Listapp.Accounts.{User, Credential}

  def list_users do
    User
    |> Repo.all()
    |> Repo.preload(:credential)
  end

  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload(:credential)
  end

  def get_user_by(params) do
    Enum.find(list_users(), fn map ->
      Enum.all?(params, fn {key, val} ->
        Map.get(map, key) == val end)
    end)
  end


  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.changeset/2)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.changeset/2)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  # CREDENTIALS

  def list_credentials do
    Repo.all(Credential)
  end

  def get_credential!(id), do: Repo.get!(Credential, id)

  def create_credential(attrs \\ %{}) do
    %Credential{}
    |> Credential.changeset(attrs)
    |> Repo.insert()
  end

  def update_credential(%Credential{} = credential, attrs) do
    credential
    |> Credential.changeset(attrs)
    |> Repo.update()
  end

  def delete_credential(%Credential{} = credential) do
    Repo.delete(credential)
  end

  def change_credential(%Credential{} = credential) do
    Credential.changeset(credential, %{})
  end

  def get_user_by_email(email) do
    query =
      from u in User,
        inner_join: c in assoc(u, :credential),
        where: c.email == ^email,
        preload: [credential: c]

    Repo.one!(query)
  end

  def authenticate_by_email_and_password(email, password) do
    user = get_user_by_email(email)

    cond do
      user && Argon2.verify_pass(password, user.credential.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true -> 
        Argon2.no_user_verify()
        {:error, :not_found}
    end
  end

  def authenticate_by_username_and_password(username, password) do
    user = get_user_by(username: username)

    cond do
      user && Argon2.verify_pass(password, user.credential.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true -> 
        Argon2.no_user_verify()
        {:error, :not_found}
    end
  end
  # REGISTRATION

  # def change_registration(%User{} = user, params) do 
  #   User.registration_changeset(user, params)
  # end

  # def register_user(attrs \\ %{}) do
  #   %User{}
  #   |> User.registration_changeset(attrs)
  #   |> Repo.insert()
  # end

end
