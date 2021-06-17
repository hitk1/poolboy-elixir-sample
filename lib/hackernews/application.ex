defmodule Hackernews.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  defp poolboy_config do
    [
      name: {:local, :poolworker},
      worker_module: Hackernews.PoolWorker,
      size: 0,
      max_overflow: 200
    ]
  end

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Hackernews.Repo,
      # Start the Telemetry supervisor
      HackernewsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Hackernews.PubSub},
      # Start the Endpoint (http/https)
      HackernewsWeb.Endpoint,
      # Start a worker by calling: Hackernews.Worker.start_link(arg)
      # {Hackernews.Worker, arg}
      :poolboy.child_spec(:poolworker, poolboy_config())
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hackernews.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HackernewsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
