# Citation: taken largely from NatTuck lens application

defmodule Trans.Photos do
  @moduledoc """
  The Photos context.
  """

  import Ecto.Query, warn: false
  alias Trans.Repo

  alias Trans.Photos.Photo

  @doc """
  Returns the list of photos.

  ## Examples

      iex> list_photos()
      [%Photo{}, ...]

  """
  def list_photos do
    Repo.all(Photo)
  end

  # def recent_photos(nn) do
  #   Repo.all(
  #     from pp in Photo,
  #       order_by: [desc: pp.inserted_at],
  #       preload: [:user, :photo_tags, :tags],
  #       limit: ^nn
  #   )
  # end

  @doc """
  Gets a single photo.

  Raises `Ecto.NoResultsError` if the Photo does not exist.

  ## Examples

      iex> get_photo!(123)
      %Photo{}

      iex> get_photo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_photo!(id) do
    Repo.one!(
      from p in Photo,
        where: p.id == ^id,
        preload: [:user]
    )
  end

  def get_photo(id) do
    Repo.one(
      from p in Photo,
        where: p.id == ^id,
        preload: [:user]
    )
  end

  def get_user_photo!(user_id) do
    Repo.one!(
      from p in Photo,
        where: p.user_id == ^user_id
      # preload: [:user]
    )
  end

  def get_user_photo(user_id) do
    Repo.one(
      from p in Photo,
        where: p.user_id == ^user_id
    )
  end

  def get_id_photo(username) do
    user_id = Trans.Users.get_id_by_username(username)

    Repo.one(
      from p in Photo,
        where: p.user_id == ^user_id
    )
  end

  @doc """
  Creates a photo.

  ## Examples

      iex> create_photo(%{field: value})
      {:ok, %Photo{}}

      iex> create_photo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_photo(attrs \\ %{}, user_id) do
    if get_user_photo(user_id) do
      delete_user_photo(user_id)
    end

    %Photo{}
    |> Photo.changeset(attrs)
    |> Repo.insert()
  end

  def create_default(_params, user_id) do
    %Photo{}
    |> Photo.changeset("assets/static/images/dachshund.jpg", [user_id, true])
    |> Repo.insert()
  end

  @doc """
  Updates a photo.

  ## Examples

      iex> update_photo(photo, %{field: new_value})
      {:ok, %Photo{}}

      iex> update_photo(photo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_photo(%Photo{} = photo, attrs) do
    photo
    |> Photo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Photo.

  ## Examples

      iex> delete_photo(photo)
      {:ok, %Photo{}}

      iex> delete_photo(photo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_photo(%Photo{} = photo) do
    Repo.delete(photo)
  end

  def delete_user_photo(user_id) do
    get_user_photo!(user_id)
    |> delete_photo()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking photo changes.

  ## Examples

      iex> change_photo(photo)
      %Ecto.Changeset{source: %Photo{}}

  """
  def change_photo(%Photo{} = photo) do
    Photo.changeset(photo, %{})
  end
end
