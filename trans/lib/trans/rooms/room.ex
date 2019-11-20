defmodule Trans.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias Trans.Rooms.Room

  schema "rooms" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, max: 30)
  end
end
