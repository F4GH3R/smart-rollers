defmodule Pluggy.Pizza do
  defstruct(id: nil, name: "", ingredients: [])

  alias Pluggy.Pizza

#  def all do
#     Postgrex.query!(DB, "SELECT * FROM fruits", [], pool: DBConnection.ConnectionPool).rows
#     |> to_struct_list

#    Postgrex.query!(DB, "
#      SELECT pizzas_ingredients_rel.pizza_id, pizzas_ingredients_rel.ing_id, pizzas.name, ingredients.name
#      FROM pizzas
#      INNER JOIN pizzas_ingredients_rel ON pizzas_ingredients_rel.pizza_id=pizzas.id
#      INNER JOIN ingredients ON ingredients.id=pizzas_ingredients_rel.ing_id",
#      [], pool: DBConnection.ConnectionPool).rows
#   |> grouped_results()

#  end

  def all do
    query = """
      SELECT pizzas.name, pizzas_ingredients_rel.pizza_id, pizzas_ingredients_rel.ing_id, ingredients.name
      FROM pizzas
      INNER JOIN pizzas_ingredients_rel ON pizzas_ingredients_rel.pizza_id = pizzas.id
      INNER JOIN ingredients ON ingredients.id = pizzas_ingredients_rel.ing_id
    """

    # Execute the SQL query
    result = Postgrex.query!(DB, query, [], pool: DBConnection.ConnectionPool).rows
    #IO.inspect(result)
    result |> to_struct_list |> IO.inspect()


   #map_pizza_id = get_pizza_id()
    #result |> grouped_results() |> pizza_list(map_pizza_id)
  end

  def get_by_id(pizza_id) do
    query = """
      SELECT pizzas.name, pizzas_ingredients_rel.pizza_id, pizzas_ingredients_rel.ing_id, ingredients.name
      FROM pizzas
      INNER JOIN pizzas_ingredients_rel ON pizzas_ingredients_rel.pizza_id = pizzas.id
      INNER JOIN ingredients ON ingredients.id = pizzas_ingredients_rel.ing_id
      WHERE pizzas.id = $1
    """

    result = Postgrex.query!(DB, query, [pizza_id] , pool: DBConnection.ConnectionPool).rows
    result |> to_struct |> IO.inspect()
  end

  # def all_ingredients do
    #   Postgrex.query!(DB, "SELECT DISTINCT name, id FROM ingredients" , [], pool: DBConnection.ConnectionPool).rows
    #   |> grouped_results()
    #   |> Enum.sort(&Fruit.order_asc_by_id/2)
    # end
    def get_pizza_id()do
      result = Postgrex.query!(DB, "SELECT name, id FROM pizzas", [], pool: DBConnection.ConnectionPool).rows
      for [pizza_name, pizza_id] <- result, do: %{name: pizza_name, id: pizza_id}
    end

    def grouped_results(rows) do
      for [pizza_name, pizza_id, ing_id, ing_name] <- rows, do: %{pizza: pizza_name, id: pizza_id, ing_id: ing_id, ingredient: ing_name}


    end

    #[%{id: 1, name: "cat"}, %{id: 2, name: "ct"}, %{id: 3, name: "T"}]

    # def pizza_list(full_list, [head | tail])do

    #   [%{pizza: pizza_name, ingredients: ingredients_list} | pizza_list(full_list, tail)]

    # end

    def get(id) do
      Postgrex.query!(DB, "SELECT * FROM fruits WHERE id = $1 LIMIT 1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
      ).rows
      |> to_struct
    end


  def update(id, params) do
    name = params["name"]
    tastiness = String.to_integer(params["tastiness"])
    id = String.to_integer(id)

    Postgrex.query!(
      DB,
      "UPDATE fruits SET name = $1, tastiness = $2 WHERE id = $3",
      [name, tastiness, id],
      pool: DBConnection.ConnectionPool
    )
  end

  def create(params) do
    name = params["name"]
    tastiness = String.to_integer(params["tastiness"])

    Postgrex.query!(DB, "INSERT INTO fruits (name, tastiness) VALUES ($1, $2)", [name, tastiness],
      pool: DBConnection.ConnectionPool
    )
  end

  def delete(id) do
    Postgrex.query!(DB, "DELETE FROM fruits WHERE id = $1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    )
  end

  def to_struct(rows) do
    rows
    |> Enum.reduce(%Pizza{}, fn([pizza_name, pizza_id, _, ingredient_name], struct) -> %{struct | id: pizza_id, name: pizza_name, ingredients: [ingredient_name| struct.ingredients] } end )
  end


  def to_struct_list(rows) do
    rows
    |> Enum.group_by(fn [_name, id, _, _] -> id end)
    |> Map.values()
    |> Enum.map(fn rows -> to_struct(rows) end)
    # |> IO.inspect
  end


end
