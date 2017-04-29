defmodule Fluff.RunStats do
  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(id) do
    Agent.get(__MODULE__, fn store ->
      store[id]
    end)
  end

  def add(id, key) do
    data = get(id) || %{}
    old_value = Map.get(data, key)
    new_value = (old_value || 0) + 1
    new_data = Map.put(data, key, new_value)
    put(id, new_data)
    new_data
  end

  def put(id, data) do
    Agent.update(__MODULE__, &Map.put(&1, id, data))
  end
end
