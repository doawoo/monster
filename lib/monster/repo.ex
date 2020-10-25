defmodule Monster.Repo do
  use Ecto.Repo,
    otp_app: :monster,
    adapter: Ecto.Adapters.Postgres
end
