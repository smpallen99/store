defmodule Store.Product do
  use Store.Web, :model
  use Whatwasit

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
  def changeset(struct, params \\ %{}, opts \\ []) do
    struct
    |> cast(params, [:name, :description, :department, :price])
    |> validate_required([:name, :description, :department, :price])
    |> prepare_version(opts)
  end
end
