defmodule TransWeb.PageController do
  use TransWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def chat(conn, %{"name" => name, "lang" => lang}) do
    user = get_session(conn, :user)
    if (user) do
      render(conn, "chat.html", name: name, user: user, lang: lang)
    else
      conn
      |> put_flash(:error, "Username cannot be blank")
      |> redirect(to: "/")
    end
  end

  def join(conn, %{"user" => user, "name" => name, "lang" => lang}) do
    conn
    |> put_session(:user, user)
    |> redirect(to: Routes.page_path(conn, :chat, name, lang: lang))
  end


end
