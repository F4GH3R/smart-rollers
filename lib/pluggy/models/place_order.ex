defmodule Pluggy.PlaceOrder do

  def all do
    query = """
      SELECT LAST(pizza_id_unique)
      FROM orders_ingredients_rel
    """

    result = Postgrex.query!(DB, query, [], pool: DBConnection.ConnectionPool).rows
    |> grouped_results()
    |> IO.inspect()
  end


  def grouped_results(rows) do
    for [id, name] <- rows, do: %{id: id, ing_name: name}
  end


  def send_order(params) do

    #make list to loop values in list

    #tar in values from form
    #for ingreidient <- ingreidients do
      list_params(params)




      IO.inspect("bannanpaj")

    #end

    # tastiness = String.to_integer(params["tastiness"])


    #make list loop to database





  end
  def list_params(params, count\\0)
  def list_params(_params, 20), do: IO.inspect("return")
  def list_params(params, count) do

    if params["#{count}"] != nil do
      ing_id = String.to_integer(params["#{count}"])
      Postgrex.query!(DB, "INSERT INTO orders_ingredients_rel(order_id, ing_id, pizza_amount) VALUES ($1, $2, $3)", [1, ing_id, 1], pool: DBConnection.ConnectionPool)
      list_params(params, count+1)
    else
      list_params(params, count+1)
    end

  end

end
