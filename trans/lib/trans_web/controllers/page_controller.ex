defmodule TransWeb.PageController do
  use TransWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
