defmodule Trans.Repo.Migrations.AddPasswordHash do
  use Ecto.Migration

  # Taken from Nat Tuck's Lens notes
  def change do
    alter table("users") do
      add :password_hash, :string, default: "", null: false
    end
  end
end
