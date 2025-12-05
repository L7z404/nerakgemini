defmodule NerakgeminiWeb.Admin.ImageLive do
  use Backpex.LiveResource,
    adapter_config: [
      schema: Nerakgemini.Blog.Image,
      repo: Nerakgemini.Repo,
      update_changeset: &Nerakgemini.Blog.Image.update_changeset/3,
      create_changeset: &Nerakgemini.Blog.Image.create_changeset/3
    ],
    layout: {NerakgeminiWeb.Layouts, :admin}

  @impl Backpex.LiveResource
  def singular_name, do: "Imagen"

  @impl Backpex.LiveResource
  def plural_name, do: "Imágenes"

  @impl Backpex.LiveResource
  def fields do
    [
      name: %{
        module: Backpex.Fields.Text,
        label: "Nombre de la imagen"
      },
      description: %{
        module: Backpex.Fields.Textarea,
        label: "Descripción (opcional)"
      },
      src: %{
        module: Backpex.Fields.Upload,
        label: "Imagen",
        upload_key: :src,
        accept: ~w(.jpg .jpeg .png .gif .webp),
        max_file_size: 5_000_000,
        put_upload_change: &put_upload_change/6,
        consume_upload: &consume_upload/4,
        remove_uploads: &remove_uploads/3,
        list_existing_files: &list_existing_files/1,
        render: fn
          %{value: value} = assigns when value == "" or is_nil(value) ->
            ~H"<p><%= Backpex.HTML.pretty_value(@value) %></p>"

          assigns ->
            ~H"""
            <img class="h-20 w-auto rounded shadow" src={file_url(@value)} alt="Imagen" />
            """
        end
      }
    ]
  end

  defp list_existing_files(%{src: src} = _item) when src != "" and not is_nil(src), do: [src]
  defp list_existing_files(_item), do: []

  def put_upload_change(_socket, params, item, uploaded_entries, removed_entries, action) do
    existing_files = list_existing_files(item) -- removed_entries

    new_entries =
      case action do
        :validate ->
          elem(uploaded_entries, 1)

        :insert ->
          elem(uploaded_entries, 0)
      end

    files = existing_files ++ Enum.map(new_entries, fn entry -> file_name(entry) end)

    case files do
      [file] ->
        Map.put(params, "src", file)

      [_file | _other_files] ->
        Map.put(params, "src", "too_many_files")

      [] ->
        Map.put(params, "src", "")
    end
  end

  defp consume_upload(_socket, _item, %{path: path} = _meta, entry) do
    file_name = file_name(entry)
    dest = Path.join([:code.priv_dir(:nerakgemini), "static", upload_dir(), file_name])

    File.mkdir_p!(Path.dirname(dest))
    File.cp!(path, dest)

    {:ok, file_url(file_name)}
  end

  defp remove_uploads(_socket, _item, removed_entries) do
    for file <- removed_entries do
      path = Path.join([:code.priv_dir(:nerakgemini), "static", upload_dir(), file])
      File.rm(path)
    end
  end

  defp file_url(file_name) do
    static_path = Path.join([upload_dir(), file_name])
    Phoenix.VerifiedRoutes.static_url(NerakgeminiWeb.Endpoint, "/" <> static_path)
  end

  defp file_name(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    entry.uuid <> "." <> ext
  end

  defp upload_dir, do: Path.join(["uploads", "blog", "images"])
end
