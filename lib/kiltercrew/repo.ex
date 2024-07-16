defmodule Kiltercrew.Repo do
  use Ecto.Repo,
    otp_app: :kiltercrew,
    adapter: Ecto.Adapters.Postgres
end
