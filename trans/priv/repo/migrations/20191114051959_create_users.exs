defmodule Trans.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :person_name, :string, null: false
      add :username, :string, null: false
      add :default_lang, :string, null: false

      timestamps()
    end

  end
end
