defmodule Nerakgemini.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      NerakgeminiWeb.Telemetry,
      Nerakgemini.Repo,
      {DNSCluster, query: Application.get_env(:nerakgemini, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Nerakgemini.PubSub},
      # Start a worker by calling: Nerakgemini.Worker.start_link(arg)
      # {Nerakgemini.Worker, arg},
      # Start to serve requests, typically the last entry
      NerakgeminiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Nerakgemini.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NerakgeminiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
