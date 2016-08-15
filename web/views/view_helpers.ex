defmodule Store.ViewHelpers do

  def authorized?(conn, action), do: Store.Authorization.authorized_link?(conn, action)
end
