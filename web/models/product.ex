defmodule Store.Product do
  use Store.Web, :model

  schema "products" do
    field :name, :string
    field :description, :string
    field :department, :string
    field :price, :decimal

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :department, :price])
    |> validate_required([:name, :description, :department, :price])
  end
end
