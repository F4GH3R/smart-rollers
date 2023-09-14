defmodule Pluggy.Order do

  defstruct(order_id: nil, pizza_amount: nil, pizza_id: nil, ingredients: [])


  alias Pluggy.Order
  def all do
    IO.puts("hej")
    query = """
      SELECT orders_ingredients_rel.order_id, orders_ingredients_rel.pizza_amount, orders_ingredients_rel.pizza_id_unique, ingredients.name FROM orders_ingredients_rel
      INNER JOIN ingredients ON orders_ingredients_rel.ing_id = ingredients.id
      INNER JOIN orders ON orders_ingredients_rel.order_id = orders.id
    """
    IO.inspect(query)
    result = Postgrex.query!(DB, query, [], pool: DBConnection.ConnectionPool).rows
    IO.inspect(result)
    result |> to_struct_list |> IO.inspect()
  end


  def to_struct(rows) do
    rows
    |> Enum.reduce(%Order{}, fn([order_id, amount, pizza_id, ingredient_name], struct) -> %{struct | order_id: order_id, pizza_amount: amount, pizza_id: pizza_id, ingredients: [ingredient_name| struct.ingredients] } end )
  end


  def to_struct_list(rows) do
    rows
    |> Enum.group_by(fn [id, _, id2, _] -> [id, id2] end)
    |> IO.inspect
    |> Map.values()
    |> IO.inspect
    |> Enum.map(fn rows -> to_struct(rows) end)


    #[1, 1, 2, "Tomato Sauce"]

    # %{
    #   1 => [
    #     [1, 1, 2, "Tomato Sauce"],
    #     [1, 1, 2, "Mozzarella"],
    #     [1, 1, 2, "Basil"],
    #     [1, 2, 1, "Tomato Sauce"]
    #   ],
    #   2 => [[2, 1, 3, "Tomato Sauce"]]
    # }

  end



end
