defmodule Store.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :description, :string
      add :department, :string
      add :price, :decimal

      timestamps()
    end

  end
end
