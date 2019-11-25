defmodule Trans.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  # Much taken from creators' timesheet applications

  schema "users" do
    field :email, :string
    field :person_name, :string
    field :username, :string
    field :default_lang, :string
    field :password_hash, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :email,
      :person_name,
      :username,
      :default_lang,
      :password,
      :password_confirmation
    ])
    |> validate_confirmation(:password)
    |> validate_length(:password, min: 8)
    |> hash_password()
    |> validate_required([:username, :password_hash])
  end

  def hash_password(cset) do
    pw = get_change(cset, :password)

    if pw do
      change(cset, Argon2.add_hash(pw))
    else
      cset
    end
  end
end
