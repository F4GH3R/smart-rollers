defmodule Pluggy.PlaceOrderController do
  require IEx

  alias Pluggy.PlaceOrder
  alias Pluggy.Pizza
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn, pizza_id) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]
    fetched_pizza = Pizza.get_by_id(String.to_integer(pizza_id))

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end

     send_resp(conn, 200, render("place_order/index", ingredients: PlaceOrder.all(), fetched_pizza: fetched_pizza, user: current_user))

  end
end
