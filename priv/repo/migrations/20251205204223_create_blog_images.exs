defmodule Nerakgemini.Repo.Migrations.CreateBlogImages do
  use Ecto.Migration

  def change do
    create table(:blog_images) do
      add :name, :string, null: false
      add :description, :text
      add :src, :string, null: false, default: ""

      timestamps(type: :utc_datetime)
    end
  end
end
