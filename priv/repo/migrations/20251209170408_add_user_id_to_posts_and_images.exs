defmodule Nerakgemini.Repo.Migrations.AddUserIdToPostsAndImages do
  use Ecto.Migration

  def change do

    alter table(:blog_posts) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end

    alter table(:blog_images) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end


    create index(:blog_posts, [:user_id])
    create index(:blog_images, [:user_id])

  end
end
