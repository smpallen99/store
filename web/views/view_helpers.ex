defmodule Store.ViewHelpers do
  def authorized?(conn, action), do: Store.Authorization.authorized_link?(conn, action)
  def admin?(conn), do: Store.Authorization.admin?(conn)
end
