# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Store.Repo.insert!(%Store.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Store.{Repo, Product}

Repo.delete_all Product

attributes = ~w(name description department price)a

products = [
  ["Programming Elixir", "Great book", "books", Decimal.new(19.99)],
  ["BeagleBone Black", "BBB Hardware", "computers", Decimal.new(89.99)]
]

for product <- products do
  attrs = Enum.zip(attributes, product) |> Enum.into(%{})
  Repo.insert! Product.changeset(%Product{}, attrs)
end
