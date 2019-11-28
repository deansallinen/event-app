defmodule Listapp.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias Listapp.Accounts.User
  alias Argon2

  schema "credentials" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email, :password])
    |> validate_required([:email])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end
  # def registration_changeset(user, params) do
  #   user
  #   |> changeset(params)
  #   |> cast(params, [:password], [])
  #   |> validate_length(:password, min: 6, max: 100)
  #   |> put_pass_hash()
  # end
  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(pass))
      _ -> 
        changeset
    end
  end
end
