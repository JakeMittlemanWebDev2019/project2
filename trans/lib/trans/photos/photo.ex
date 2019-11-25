# Citation: taken largely from NatTuck lens application

# NB: right now, using this for avatar photos -- figure out how to incorporate
# in chat (question: will photos uploaded to chat be stored? Or will they be
# temporary and deleted with the rest of chat history?)
# NB: for avatar photos, will likely need to add field to database table
# TODO: need to provide defaults
# TODO: if decide to do it this way, need function to store photo in db (?)

defmodule Trans.Photos.Photo do
  use Ecto.Schema
  import Ecto.Changeset

  # NB: removed "description"
  schema "photos" do
    field :filename, :string
    field :uuid, :string

    belongs_to :user, Trans.Users.User

    field :photo_upload, :any, virtual: true

    timestamps()
  end

  # NB: removed "description"
  @doc false
  def changeset(photo, attrs) do
    photo
    |> cast(attrs, [:user_id, :photo_upload])
    |> validate_required([:user_id, :photo_upload])
    |> generate_uuid()
    |> save_photo_upload()
  end

  def make_uuid() do
    :crypto.strong_rand_bytes(16)
    |> Base.encode16()
  end

  # Used to tie photo to user (?)
  def generate_uuid(cset) do
    if get_field(cset, :uuid) do
      cset
    else
      put_change(cset, :uuid, make_uuid())
    end
  end

  # Stores uploaded photos, each to new directory (?)
  def save_photo_upload(cset) do
    up = get_field(cset, :photo_upload)
    uuid = get_field(cset, :uuid)

    if up do
      dir = photo_upload_dir(uuid)
      File.mkdir_p!(dir)
      File.copy!(up.path, Path.join(dir, up.filename))
      put_change(cset, :filename, up.filename)
    else
      cset
    end
  end

  def photo_upload_dir(uuid) do
    base = Path.expand("~/.local/data/trans/photos/")
    Path.join(base, uuid)
  end
end
