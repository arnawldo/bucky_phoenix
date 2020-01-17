defmodule BuckyPhoenix.Repo do
  use Ecto.Repo,
    otp_app: :bucky_phoenix,
    adapter: Ecto.Adapters.Postgres
end
