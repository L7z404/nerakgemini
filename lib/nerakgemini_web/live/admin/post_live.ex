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
      subtitle: %{
        module: Backpex.Fields.Text,
        label: "Subtítulo"
      },
      image: %{
        module: Backpex.Fields.BelongsTo,
        label: "Imagen",
        display_field: :name,
        prompt: "Seleccionar imagen...",
        render: fn
          %{value: value} = assigns when value == "" or is_nil(value) ->
            ~H"<p><%= Backpex.HTML.pretty_value(@value) %></p>"

          assigns ->
            ~H"""
            <img class="h-20 w-auto rounded shadow" src={file_url(@value.src)} alt="Imagen" />
            """
        end
      },
      body: %{
        module: Backpex.Fields.Textarea,
        label: "Cuerpo"
      }
    ]
  end

    defp file_url(file_name) do
      static_path = Path.join([upload_dir(), file_name])
      Phoenix.VerifiedRoutes.static_url(NerakgeminiWeb.Endpoint, "/" <> static_path)
    end

    defp upload_dir, do: Path.join(["uploads", "blog", "images"])

end
