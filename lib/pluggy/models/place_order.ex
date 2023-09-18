defmodule Pluggy.PlaceOrder do

  def all do
    query = """
      SELECT *
      FROM ingredients
    """

    result = Postgrex.query!(DB, query, [], pool: DBConnection.ConnectionPool).rows
    |> grouped_results()
    |> IO.inspect()
  end


  def grouped_results(rows) do
    for [id, name] <- rows, do: %{id: id, ing_name: name}
  end



  def send_order(params) do
    query = """
      SELECT pizza_id_unique
      FROM orders_ingredients_rel
      WHERE id=(SELECT max(id) FROM orders_ingredients_rel)
    """
    result = Postgrex.query!(DB, query, [], pool: DBConnection.ConnectionPool).rows
    |> IO.inspect()
    |> get_new_pizza_id()
    |> IO.inspect()
    |> list_params(params)
    #[[3]]
    # > 3



    #make list to loop values in list

    #tar in values from form
    #for ingreidient <- ingreidients do





      IO.inspect("bannanpaj")

    #end

    # tastiness = String.to_integer(params["tastiness"])


    #make list loop to database





  end


  def get_new_pizza_id([]), do: 1
  def get_new_pizza_id([[id]]), do: id + 1

  def list_params(pizza_id, params, count\\0)
  def list_params(_pizza_id, _params, 20), do: IO.inspect("return")
  def list_params(pizza_id, params, count) do

    if params["#{count}"] != nil do
      ing_id = String.to_integer(params["#{count}"])
      Postgrex.query!(DB, "INSERT INTO orders_ingredients_rel(order_id, ing_id, pizza_id_unique) VALUES ($1, $2, $3)", [1, ing_id, pizza_id], pool: DBConnection.ConnectionPool)
      list_params(pizza_id, params, count+1)
    else
      list_params(pizza_id, params, count+1)
    end

  end

end
