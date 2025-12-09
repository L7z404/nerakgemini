defmodule Nerakgemini.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :title, :subtitle, :body, :image, :user, :inserted_at, :updated_at]}
  schema "blog_posts" do
    field :title, :string
    field :subtitle, :string
    field :body, :string

    belongs_to :image, Nerakgemini.Blog.Image
    belongs_to :user, Nerakgemini.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :subtitle, :body, :image_id, :user_id])
    |> validate_required([:title])
  end

  def create_changeset(post, attrs, metadata) do
    user_id = metadata[:assigns][:current_scope].user.id
    attrs = Map.put(attrs, "user_id", user_id)

    post
    |> changeset(attrs)
    |> validate_required([:user_id])
  end

  def update_changeset(post, attrs, _metadata), do: changeset(post, attrs)
end
