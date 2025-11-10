defmodule Nerakgemini.Repo do
  use Ecto.Repo,
    otp_app: :nerakgemini,
    adapter: Ecto.Adapters.MyXQL
end
