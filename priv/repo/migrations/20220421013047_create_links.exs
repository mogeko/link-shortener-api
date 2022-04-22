defmodule ShortenApi.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links, primary_key: false) do
      add :hash, :string, primary_key: true, null: false
      add :url, :string, null: false

      timestamps()
    end

    create unique_index(:links, [:url])
  end
end
