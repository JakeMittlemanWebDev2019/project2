defmodule Trans.Repo do
  use Ecto.Repo,
    otp_app: :trans,
    adapter: Ecto.Adapters.Postgres
end
