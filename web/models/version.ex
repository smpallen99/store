defmodule Store.Version do

  import Ecto.Query

  @base Mix.Project.get |> Module.split |> Enum.reverse |> Enum.at(1)
  @version_module Module.concat([@base, Whatwasit, Version])

  # copied from deps/whatwasit/priv/templates/whatwasit.install/models/whatwasit/version_map.ex
  def versions(schema, opts \\ []) do
    repo = opts[:repo] || Application.get_env(:whatwasit, :repo)
    id = schema.id
    type = Whatwasit.Utils.item_type schema
    Ecto.Query.where(@version_module, [a], a.item_id == ^id and a.item_type == ^type)
    |> Ecto.Query.order_by(desc: :id)
    |> repo.all
    |> Enum.map(fn item ->
      %{name: item.whodoneit["name"], action: item.action, object: Whatwasit.Utils.cast(schema, item.object)}
    end)
  end

end
