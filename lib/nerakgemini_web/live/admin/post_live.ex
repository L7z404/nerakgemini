defmodule NerakgeminiWeb.Admin.PostLive do
  use Backpex.LiveResource,
    adapter_config: [
      schema: Nerakgemini.Blog.Post,
      repo: Nerakgemini.Repo,
      update_changeset: &Nerakgemini.Blog.Post.update_changeset/3,
      create_changeset: &Nerakgemini.Blog.Post.create_changeset/3
    ],
    layout: {NerakgeminiWeb.Layouts, :admin}

  @impl Backpex.LiveResource
  def singular_name, do: "Publicación"

  @impl Backpex.LiveResource
  def plural_name, do: "Publicaciones"

  @impl Backpex.LiveResource
  def fields do
    [
      title: %{
        module: Backpex.Fields.Text,
        label: "Título"
      },
      views: %{
        module: Backpex.Fields.Number,
        label: "Vistas"
      }
    ]
  end
end
