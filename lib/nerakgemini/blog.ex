defmodule Nerakgemini.Blog do
  @moduledoc """
  The Blog context - handles all blog-related business logic.
  """

  import Ecto.Query, warn: false
  alias Nerakgemini.Repo
  alias Nerakgemini.Blog.Post
  alias Nerakgemini.Blog.Image


  # -------------------------Post-------------------------
  @doc """
  Returns the list of posts.
  """
  def list_posts do
    Repo.all(Post) |> Repo.preload([:image, :user])
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.
  """
  def get_post!(id) do
    Repo.get!(Post, id) |> Repo.preload([:image, :user])
  end

  @doc """
  Creates a post.
  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.
  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.
  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.
  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  # -------------------------Image-------------------------
  @doc """
  Returns the list of images.
  """
  def list_images do
    Repo.all(Image) |> Repo.preload(:user)
  end

  @doc """
  Gets a single image.

  Raises `Ecto.NoResultsError` if the Image does not exist.
  """
  def get_image!(id) do
    Repo.get!(Image, id) |> Repo.preload(:user)
  end

  @doc """
  Creates a image.
  """
  def create_image(attrs \\ %{}) do
    %Image{}
    |> Image.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an image.
  """
  def update_image(%Image{} = image, attrs) do
    image
    |> Image.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an image.
  """
  def delete_image(%Image{} = image) do
    Repo.delete(image)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking image changes.
  """
  def change_image(%Image{} = image, attrs \\ %{}) do
    Image.changeset(image, attrs)
  end
end
