defmodule Mix.Tasks.Seed do
  use Mix.Task

  alias Mix.Tasks.Seed

  @shortdoc "Resets & seeds the DB."
  def run(_) do
    Mix.Task.run "app.start"
    drop_tables()
    create_tables()
    seed_data()
  end

  defp drop_tables() do
    IO.puts("Dropping tables")
    Postgrex.query!(DB, "DROP TABLE IF EXISTS fruits", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS users", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS pizzas", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS ingredients", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS orders", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS pizzas_ingredients_rel", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS orders_ingredients_rel", [], pool: DBConnection.ConnectionPool)


  end

  defp create_tables() do
    IO.puts("Creating tables")
    Postgrex.query!(DB, "Create TABLE fruits (id SERIAL, name VARCHAR(255) NOT NULL, tastiness INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE pizzas (id SERIAL, name VARCHAR(255) NOT NULL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE ingredients (id SERIAL, name VARCHAR(255) NOT NULL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE orders (id SERIAL, test INTEGER)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE pizzas_ingredients_rel (id SERIAL, pizza_id INTEGER, ing_id INTEGER)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE orders_ingredients_rel (id SERIAL, order_id INTEGER, ing_id INTEGER, pizza_amount INTEGER, pizza_id_unique INTEGER)", [], pool: DBConnection.ConnectionPool)
  end

  def pizzas_ingredients_rel(pizza_id, ing_id) do
    Postgrex.query!(DB, "INSERT INTO pizzas_ingredients_rel(pizza_id, ing_id) VALUES($1, $2)", [pizza_id, ing_id], pool: DBConnection.ConnectionPool)
  end

  def orders_ingredients_rel(order_id, ing_id, pizza_amount, pizza_id_unique) do
    Postgrex.query!(DB, "INSERT INTO orders_ingredients_rel(order_id, ing_id, pizza_amount, pizza_id_unique) VALUES($1, $2, $3, $4)", [order_id, ing_id, pizza_amount, pizza_id_unique], pool: DBConnection.ConnectionPool)
  end

  def orders_add(id) do
    Postgrex.query!(DB, "INSERT INTO orders(id) VALUES($1)", [id], pool: DBConnection.ConnectionPool)
  end





  #tests
  defp seed_data() do
    #order 1
    orders_ingredients_rel(1,1,1,2)
    orders_ingredients_rel(1,2,1,2)
    orders_ingredients_rel(1,3,1,2)
    orders_ingredients_rel(1,1,2,1)
    orders_ingredients_rel(2,1,1,3)

    orders_add(1)
    orders_add(2)
    orders_add(3)


    IO.puts("Seeding data")
    Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Apple", 5], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Pear", 4], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Banana", 7], pool: DBConnection.ConnectionPool)

    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Tomato Sauce"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Mozzarella"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Basil"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Ham"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Mushroom"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Artichoke"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Olives"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Parmesan"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Pecorino"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Gorgonzola"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Paprica"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Aubergine"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Zucchini"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Salami"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Chili"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Family Pizza"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO ingredients(name) VALUES($1)", ["Glutenfree"], pool: DBConnection.ConnectionPool)


    Postgrex.query!(DB, "INSERT INTO pizzas(name) VALUES($1)", ["Margherita"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO pizzas(name) VALUES($1)", ["Marinara"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO pizzas(name) VALUES($1)", ["Prosciutto e funghi"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO pizzas(name) VALUES($1)", ["Quattro stagioni"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO pizzas(name) VALUES($1)", ["Capricciosa"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO pizzas(name) VALUES($1)", ["Quattro formaggi"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO pizzas(name) VALUES($1)", ["Ortolana"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO pizzas(name) VALUES($1)", ["Diavola"], pool: DBConnection.ConnectionPool)

    # Postgrex.query!(DB, "INSERT INTO pizzas_ingredients_rel(pizza_id, ing_id) VALUES($1, $2)", [1, 1], pool: DBConnection.ConnectionPool)
    # Postgrex.query!(DB, "INSERT INTO pizzas_ingredients_rel(pizza_id, ing_id) VALUES($1, $2)", [1, 2], pool: DBConnection.ConnectionPool)
    # Postgrex.query!(DB, "INSERT INTO pizzas_ingredients_rel(pizza_id, ing_id) VALUES($1, $2)", [1, 3], pool: DBConnection.ConnectionPool)

    # Margarita
    pizzas_ingredients_rel(1, 1); pizzas_ingredients_rel(1, 2); pizzas_ingredients_rel(1, 3)
    # Marinara
    pizzas_ingredients_rel(2, 1)
    #Poscuitto
    pizzas_ingredients_rel(3, 1); pizzas_ingredients_rel(3, 2); pizzas_ingredients_rel(3,4); pizzas_ingredients_rel(3, 5)
    #Stagioni
    pizzas_ingredients_rel(4, 1); pizzas_ingredients_rel(4, 2); pizzas_ingredients_rel(4, 4); pizzas_ingredients_rel(4, 5); pizzas_ingredients_rel(4, 6); pizzas_ingredients_rel(4, 7)
    #Capricciosa
    pizzas_ingredients_rel(5, 1); pizzas_ingredients_rel(5, 2); pizzas_ingredients_rel(5, 4); pizzas_ingredients_rel(5, 5); pizzas_ingredients_rel(5, 6)
    #Formagi
    pizzas_ingredients_rel(6, 1); pizzas_ingredients_rel(6, 2); pizzas_ingredients_rel(6, 8); pizzas_ingredients_rel(6, 9); pizzas_ingredients_rel(6, 10)
    #Ortolana
    pizzas_ingredients_rel(7, 1); pizzas_ingredients_rel(7, 2); pizzas_ingredients_rel(7, 11); pizzas_ingredients_rel(7, 12); pizzas_ingredients_rel(7, 13)
    #Diavola
    pizzas_ingredients_rel(8, 1); pizzas_ingredients_rel(8, 2); pizzas_ingredients_rel(8, 14); pizzas_ingredients_rel(8, 11); pizzas_ingredients_rel(8, 15)


    # var = Postgrex.query!(DB, "SELECT pizzas_ingredients_rel.pizza_id, pizzas_ingredients_rel.ing_id, pizzas.name, ingredients.name FROM pizzas INNER JOIN pizzas_ingredients_rel ON pizzas_ingredients_rel.pizza_id=pizzas.id INNER JOIN ingredients ON ingredients.id=pizzas_ingredients_rel.ing_id", [], pool: DBConnection.ConnectionPool).rows
    # var = Pluggy.Fruit.to_struct_test(var)
    # IO.inspect(var)




  end

end
