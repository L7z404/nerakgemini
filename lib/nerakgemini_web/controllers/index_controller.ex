defmodule NerakgeminiWeb.IndexController do
  use NerakgeminiWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
