defmodule Hackernews.Repo do
  use Ecto.Repo,
    otp_app: :hackernews,
    adapter: Ecto.Adapters.Postgres
end
