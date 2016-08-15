defmodule Store.Authorization do

  import Phoenix.Controller
  import Plug.Conn
  import Store.Router.Helpers

  def admin?(conn) do
    case Coherence.current_user(conn) do
      nil -> false
      user -> user.admin
    end
  end

  def authorized_link?(conn, :index), do: true
  def authorized_link?(conn, :show), do: true
  def authorized_link?(conn, _), do: admin?(conn)

  # authorize plug
  def authorize(conn, opts \\ []) do
    if admin? conn do
      conn
    else
      conn
      |> put_flash(:error, "Unauthorized")
      |> redirect(to: product_path(conn, :index))
      |> halt
    end
  end
end
