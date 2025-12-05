defmodule Nerakgemini.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :title, :subtitle, :body, :image, :inserted_at, :updated_at]}
  schema "blog_posts" do
    field :title, :string
    field :subtitle, :string
    field :body, :string

    belongs_to :image, Nerakgemini.Blog.Image

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :subtitle, :body, :image_id])
    |> validate_required([:title])
  end

  def create_changeset(post, attrs, _metadata), do: changeset(post, attrs)
  def update_changeset(post, attrs, _metadata), do: changeset(post, attrs)
end
