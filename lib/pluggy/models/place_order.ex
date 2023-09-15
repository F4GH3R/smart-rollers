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
end
