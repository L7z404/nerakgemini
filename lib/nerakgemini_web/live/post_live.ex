defmodule NerakgeminiWeb.Live.PostLive do
  use Backpex.LiveResource,
    adapter_config: [
      schema: Nerakgemini.Blog.Post,
      repo: Nerakgemini.Repo,
      update_changeset: &Nerakgemini.Blog.Post.update_changeset/3,
      create_changeset: &Nerakgemini.Blog.Post.create_changeset/3
    ],
    layout: {NerakgeminiWeb.Layouts, :admin}

  @impl Backpex.LiveResource
  def singular_name, do: "Post"

  @impl Backpex.LiveResource
  def plural_name, do: "Posts"

  @impl Backpex.LiveResource
  def fields do
    [
      title: %{
        module: Backpex.Fields.Text,
        label: "Title"
      },
      views: %{
        module: Backpex.Fields.Number,
        label: "Views"
      }
    ]
  end
end
