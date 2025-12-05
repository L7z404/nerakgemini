defmodule Nerakgemini.Repo.Migrations.AddFieldsToBlogPosts do
  use Ecto.Migration

  def change do
    alter table(:blog_posts) do
      add :subtitle, :string
      add :body, :text
      add :image_id, references(:blog_images, on_delete: :nilify_all)
    end

    create index(:blog_posts, [:image_id])
  end
end
