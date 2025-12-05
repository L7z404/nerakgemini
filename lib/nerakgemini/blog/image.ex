defmodule Nerakgemini.Blog.Image do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :description, :src, :inserted_at, :updated_at]}
  schema "blog_images" do
    field :name, :string
    field :description, :string
    field :src, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:name, :description, :src])
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

  def create_changeset(image, attrs, _metadata), do: changeset(image, attrs)
  def update_changeset(image, attrs, _metadata), do: changeset(image, attrs)
end
