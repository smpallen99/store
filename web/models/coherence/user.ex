defmodule Store.User do
  use Store.Web, :model
  use Coherence.Schema

  schema "users" do
    field :name, :string
    field :email, :string
    field :admin, :boolean, default: false
    coherence_schema

    timestamps
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :email, :admin] ++ coherence_fields)
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
    |> validate_coherence(params)
  end
end
