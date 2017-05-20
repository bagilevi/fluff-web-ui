defmodule Fluff.RunTracker do
  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def load(uuid) do
    Agent.get(__MODULE__, fn store -> store[uuid] end)
  end

  def save_run(run) do
    put(run.uuid, run)
    run
  end

  defp put(id, data) do
    Agent.update(__MODULE__, &Map.put(&1, id, data))
  end
end
