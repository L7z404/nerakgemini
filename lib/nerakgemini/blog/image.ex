defmodule Nerakgemini.Blog.Image do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :description, :src, :user, :inserted_at, :updated_at]}
  schema "blog_images" do
    field :name, :string
    field :description, :string
    field :src, :string

    belongs_to :user, Nerakgemini.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:name, :description, :src, :user_id])
    |> validate_required([:name, :src])
    |> validate_change(:src, fn
      :src, "too_many_files" ->
        [src: "debe ser exactamente un archivo"]

      :src, "" ->
        [src: "no puede estar vacío"]

      :src, _src ->
        []
    end)
  end

  def create_changeset(image, attrs, metadata) do
    user_id = metadata[:assigns][:current_scope].user.id
    attrs = Map.put(attrs, "user_id", user_id)

    image
    |> changeset(attrs)
    |> validate_required([:user_id])
  end

  def update_changeset(image, attrs, _metadata), do: changeset(image, attrs)
end
