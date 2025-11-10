defmodule NerakgeminiWeb.PageController do
  use NerakgeminiWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
