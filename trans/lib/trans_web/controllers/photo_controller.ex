# Citation: taken largely from NatTuck lens application

defmodule TransWeb.PhotoController do
  use TransWeb, :controller

  alias Trans.Photos
  alias Trans.Photos.Photo

  def index(conn, _params) do
    photos = Photos.list_photos()
    render(conn, "index.html", photos: photos)
  end

  def new(conn, _params) do
    changeset = Photos.change_photo(%Photo{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"photo" => photo_params}) do
    photo_params = Map.put(photo_params, "user_id", conn.assigns[:current_user].id)

    IO.inspect(photo_params["photo_upload"])

    case Photos.create_photo(photo_params) do
      {:ok, photo} ->
        conn
        |> put_flash(:info, "Photo created successfully.")
        |> redirect(to: Routes.photo_path(conn, :show, photo))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    photo = Photos.get_photo!(id)
    render(conn, "show.html", photo: photo)
  end

  def file(conn, %{"id" => id}) do
    photo = Photos.get_photo!(id)
    dir = Photo.photo_upload_dir(photo.uuid)
    data = File.read!(Path.join(dir, photo.filename))

    conn
    |> put_resp_header("content-type", "image/jpeg")
    |> put_resp_header("content-disposition", "inline")
    |> send_resp(200, data)
  end

  def edit(conn, %{"id" => id}) do
    photo = Photos.get_photo!(id)
    changeset = Photos.change_photo(photo)
    render(conn, "edit.html", photo: photo, changeset: changeset)
  end

  def update(conn, %{"id" => id, "photo" => photo_params}) do
    photo = Photos.get_photo!(id)

    case Photos.update_photo(photo, photo_params) do
      {:ok, photo} ->
        conn
        |> put_flash(:info, "Photo updated successfully.")
        |> redirect(to: Routes.photo_path(conn, :show, photo))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", photo: photo, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    photo = Photos.get_photo!(id)
    {:ok, _photo} = Photos.delete_photo(photo)

    conn
    |> put_flash(:info, "Photo deleted successfully.")
    |> redirect(to: Routes.photo_path(conn, :index))
  end
end
