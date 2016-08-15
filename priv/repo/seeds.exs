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

alias Store.{Repo, Product, User}

Repo.delete_all Product
Repo.delete_all User

User.changeset(%User{}, %{name: "Admin User", email: "admin@example.com", password: "secret", password_confirmation: "secret", admin: true})
|> Store.Repo.insert!
|> Coherence.ControllerHelpers.confirm!

User.changeset(%User{}, %{name: "Test User", email: "user@example.com", password: "secret", password_confirmation: "secret"})
|> Store.Repo.insert!
|> Coherence.ControllerHelpers.confirm!

attributes = ~w(name description department price)a

products = [
  ["Programming Elixir", "You want to explore functional programming, but are put off by the academic feel (tell me about monads just one more time). ", "Books", Decimal.new(46.82)],
  ["Elixir in Action", "Elixir in Action teaches you to apply the new Elixir programming language to practical problems associated with scalability, concurrency, fault tolerance, and high availability.", "Books", Decimal.new(48.27)],
  ["BeagleBone Black", "BBB Hardware", "electronics", Decimal.new(117.22)],
  ["Raspberry Pi 3 Model B Board", "Quad-Core Broadcom BCM2837 64bit ARMv8 processor 1.2GHz", "Electronics", Decimal.new(57.49)],
  ["Samsung Galaxy S7 G930F 32GB", "Factory Unlocked GSM Smartphone International Version No Warranty (Black)", "Cell Phones", Decimal.new(799.00)],
]

for product <- products do
  attrs = Enum.zip(attributes, product) |> Enum.into(%{})
  Repo.insert! Product.changeset(%Product{}, attrs)
end
