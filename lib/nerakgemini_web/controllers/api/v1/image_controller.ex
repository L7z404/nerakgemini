defmodule NerakgeminiWeb.API.V1.ImageController do
  use NerakgeminiWeb, :controller

  alias Nerakgemini.Blog

  def index(conn, _params) do
    images = Blog.list_images()
    json(conn, %{images: images})
  end

  def show(conn, %{"id" => id}) do
    image = Blog.get_image!(id)
    json(conn, %{image: image})
  end
end
