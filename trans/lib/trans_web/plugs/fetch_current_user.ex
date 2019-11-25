defmodule TransWeb.Plugs.FetchCurrentUser do
  import Plug.Conn

  # Taken from Nat's Notes on the Lens app

  def init(args), do: args

  def call(conn, _args) do
    user = Trans.Users.get_user(get_session(conn, :user_id) || -1)

    if user do
      assign(conn, :current_user, user)
    else
      assign(conn, :current_user, nil)
    end
  end
end
