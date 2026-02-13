defmodule NerakgeminiWeb.PageController do
  use NerakgeminiWeb, :controller

  def home(conn, _params) do
    if conn.assigns[:current_scope] do
      render(conn, :home)
    else
      redirect(conn, to: ~p"/users/log-in")
    end
  end
end
