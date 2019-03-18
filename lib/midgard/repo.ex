defmodule Midgard.Repo do
  use Ecto.Repo,
    otp_app: :midgard,
    adapter: Ecto.Adapters.Postgres
end
