defmodule NerakgeminiWeb.Admin.UploadController do
  @moduledoc """
  Handles file uploads from the Trix rich text editor in the admin panel.

  Exposes a single `POST /admin/uploads/images` endpoint that receives a
  multipart file, saves it to `priv/static/uploads/blog/images/`, and returns
  the public URL so Trix can embed the image inline in the editor body.
  """

  use NerakgeminiWeb, :controller

  # Destination directory relative to priv/static
  @upload_dir Path.join(["uploads", "blog", "images"])

  @doc """
  Accepts a multipart file upload and saves it to the static uploads directory.

  Returns `{"url": "..."}` on success, which the Trix JS hook uses to set the
  attachment URL and embed the image in the editor.
  """
  def create(conn, %{"file" => %Plug.Upload{} = upload}) do
    ext = Path.extname(upload.filename)
    # Use a UUID filename to avoid collisions and not expose original filenames
    file_name = "#{Ecto.UUID.generate()}#{ext}"
    dest = Path.join([:code.priv_dir(:nerakgemini), "static", @upload_dir, file_name])

    # Ensure the upload directory exists before copying
    File.mkdir_p!(Path.dirname(dest))
    File.cp!(upload.path, dest)

    # Build the full public URL using the configured endpoint host
    url = Phoenix.VerifiedRoutes.static_url(NerakgeminiWeb.Endpoint, "/#{@upload_dir}/#{file_name}")
    json(conn, %{url: url})
  end

  # Fallback when no file param is present in the request
  def create(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "missing file"})
  end
end
