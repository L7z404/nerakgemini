defmodule Nerakgemini.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "blog_posts" do
    field :title, :string
    field :views, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :views])
    |> validate_required([:title, :views])
  end

  def create_changeset(post, attrs, _metadata), do: changeset(post, attrs)
  def update_changeset(post, attrs, _metadata), do: changeset(post, attrs)
end
