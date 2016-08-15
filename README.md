# Store

A Coherence and Whatwasit Demonstration project.

## Step 1 - Create the Product Model

Generate the model and scaffolding

```shell
$ mix phoenix.gen.html Product products name description department price:decimal
```

Update the routes:

```elixir
# web/router.ex
  ...
  scope "/", Store do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/products", ProductController  # add this
  end
  ...
```

Run the migration:

```shell
$ mix ecto.migrate
```

Add some seed data:

```elixir
# priv/repo/seeds.exs
alias Store.{Repo, Product}

Repo.delete_all Product

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
```

Seed the database and run the server

```shell
$ mix run priv/repo/seeds.exs
$ iex -S mix phoenix.server
```

Test the Product Model by loading `http:/localhost/products` in your browser

## Step 2 - Add Coherence

Add the Coherence Dependency

```elixir
# mix.exs
  def deps do
    ...
    {:coherence, "~> 0.2"}
    ...
  end
```

Get and compile deps

```shell
$ mix do deps.get, deps.compile
```

