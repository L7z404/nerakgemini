defmodule NerakgeminiWeb.API.V1.PostController do
  use NerakgeminiWeb, :controller

  alias Nerakgemini.Blog

  def index(conn, _params) do
    posts = Blog.list_posts()
    json(conn, %{posts: posts})
  end

  def show(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    json(conn, %{post: post})
  end
end
