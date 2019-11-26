defmodule TransWeb.PageController do
  use TransWeb, :controller

  alias Trans.Rooms
  alias Trans.Rooms.Room

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def home(conn, _params) do
    rooms = Rooms.list_rooms()
    render(conn, "home.html", rooms: rooms)
  end

  def chat(conn, %{"name" => name}) do
    user = get_session(conn, :user)
    IO.puts(user)
    if (user) do
      if (!Rooms.get_room_by_name(name)) do
        Rooms.create_room(%{"name" => name})
      end
      render(conn, "chat.html", name: name, user: user)
    else
      conn
      |> put_flash(:error, "Username cannot be blank")
      |> redirect(to: "/")
    end
  end

  def join(conn, %{"user" => user, "name" => name}) do
    conn
    |> put_session(:user, user)
    |> redirect(to: Routes.page_path(conn, :chat, name))
  end
end
