defmodule NerakgeminiWeb.Admin.RedirectController do
  use NerakgeminiWeb, :controller

  def redirect_to_posts(conn, _params) do
    conn
    |> Phoenix.Controller.redirect(to: ~p"/admin/posts")
    |> Plug.Conn.halt()
  end
end
