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
     {:coherence, github: "smpallen99/coherence"}
    ...
  end
```

Add the coherence application

```elixir
# mix.exs
  def application do
    [mod: {Store, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex, :coherence]]
  end
```

Get and compile deps

```shell
$ mix do deps.get, deps.compile
```

Checkout the coherence installer help

```shell
$ mix help coherence.install
```

Install the `--full-confirmable` option. This installs the following Coherence options:

* :authenticatable -- Add or modify user model for authentication
* :recoverable -- Support password recovery
* :lockable  -- Lock account after x failed login attempts
* :trackable -- Add last login IP and timestamps
* :unlockable_with_token - Support unlock link with token
* :confirmable  - Require account to be confirmed before logging in
* :registerable - Support registrations

```shell
$ mix coherence.install --full-confirmable
```

For this example, we are going to use a simple authorization approach to allow admin account to be able to add/modify/delete products. So, lets add an `admin` boolean field to the user model before running the migration.

```elixir
# priv/repo/migrations/xxx_create_coherence_user.exs
defmodule Store.Repo.Migrations.CreateCoherenceUser do
  use Ecto.Migration
  def change do
    create table(:users) do
      ...
      add :admin, :boolean, default: false
      ...
    end
    ...
  end
end
```

Add the admin field to user model

```elixir
# web/models/coherence/user.ex
defmodule Store.User do
  use Store.Web, :model
  use Coherence.Schema

  schema "users" do
    field :name, :string
    field :email, :string
    field :admin, :boolean, default: false   # add this
    coherence_schema

    timestamps
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :email, :admin] ++ coherence_fields)  # add :admin here
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
    |> validate_coherence(params)
  end
end
```
Follow the instructions printed by `mix coherence.install`

Update the routes:

We are going to add the coherence routes as well as setup the product routes so that index and show routes can be used by anyone, but the remaining routes will require login.

```elixir
defmodule Store.Router do
  use Store.Web, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session  # Add this
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true    # Add this
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Add this block
  scope "/" do
    pipe_through :browser
    coherence_routes
  end

  # Add this block
  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end

  scope "/", Store do
    pipe_through :browser
    get "/", PageController, :index
    resources "/products", ProductController, only: [:index, :show]
  end

  scope "/", Store do
    pipe_through :protected
    # Add your protected routes here
    resources "/products", ProductController, except: [:index, :show]
  end
end
```

Add a couple users to your seeds file

```elixir
alias Store.{Repo, Product, User}

...
Repo.delete_all User

User.changeset(%User{}, %{name: "Admin User", email: "admin@example.com", password: "secret", password_confirmation: "secret", admin: true})
|> Store.Repo.insert!
|> Coherence.ControllerHelpers.confirm!

User.changeset(%User{}, %{name: "Test User", email: "user@example.com", password: "secret", password_confirmation: "secret"})
|> Store.Repo.insert!
|> Coherence.ControllerHelpers.confirm!```
...
```

Add some authentication links to the layout

```elixir
# web/templates/layout/app.html.eex
    ...
    <div class="container">
      <header class="header">
        <nav role="navigation">
          <ul class="nav nav-pills pull-right">
            <%= Store.Coherence.ViewHelpers.coherence_links(@conn, :layout) %>
          </ul>
        </nav>
      </header>
      ...
```

