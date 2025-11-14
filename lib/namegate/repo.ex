defmodule Namegate.Repo do
  use Ecto.Repo,
    otp_app: :namegate,
    adapter: Ecto.Adapters.Postgres
end
