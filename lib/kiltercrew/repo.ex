defmodule Kiltercrew.Repo do
  use Ecto.Repo,
    otp_app: :kiltercrew,
    # adapter: Ecto.Adapters.Postgres
    adapter: Ecto.Adapters.SQLite3
end
