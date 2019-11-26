defmodule TransWeb.SessionController do
  use TransWeb, :controller

  # Citation for this file: Nat Tuck lens app
  # What this is doing: cookies in browser are storing user
  # sessions, so this conttrols the login/out of a session

  # new -- login form
  def new(conn, _params) do
    render(conn, "new.html")
  end

  # actually log in
  def create(conn, %{"username" => username, "password" => password}) do
    user = Trans.Users.authenticate(username, password)

    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_session(:user, username)
      |> put_flash(:info, "Welcome back #{user.username}")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Login failed.")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  # log out
  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
