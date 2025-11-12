defmodule Nerakgemini.Repo do
  use Ecto.Repo,
    otp_app: :nerakgemini,
    adapter: Ecto.Adapters.Postgres
end
