defmodule Hackernews.Repo.Migrations.CreateStories do
  use Ecto.Migration

  def change do
    create table(:stories) do
      add :by, :string
      add :descendants, :integer
      add :key, :integer
      add :score, :integer
      add :time, :integer
      add :title, :string
      add :type, :string
      add :url, :string

      timestamps()
    end
  end
end
